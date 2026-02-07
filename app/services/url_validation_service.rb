class UrlValidationService
  include HTTParty

  base_uri "https://hatamo-antique-auth-api.hf.space"

  def initialize(auction_url, user: nil)
    @auction_url = auction_url
    @user = user
  end

  # Calls external service and optionally creates Auction + ImageAnalysis when user provided.
  # Returns a hash with :success and created objects or :error with message.
  def call
    return { error: "Invalid URL format" } unless valid_url_format?

    response = self.class.post("/validate_url", {
      body: { url: @auction_url },
      headers: { "Content-Type" => "application/x-www-form-urlencoded" }
    })

    puts "URL Validation Response: #{response.body}"

    unless response.success?
      return { error: "Validation service error", status: response.code, body: response.body }
    end

    parsed = JSON.parse(response.body)

    # Normalize where payload may be nested. Examples vary, so try a few heuristics.
    validation_result = parsed["validation_result"] || parsed

    evaluation = nil
    if validation_result.is_a?(Hash) && validation_result["evaluation"].is_a?(Hash)
      evaluation = validation_result["evaluation"]
    elsif validation_result.is_a?(Hash) && (validation_result["title"] || validation_result["image_urls"] || validation_result["evaluation_status"]) 
      evaluation = validation_result
    else
      # Try to find a nested hash that looks like the evaluation payload
      evaluation = parsed.values.find { |v| v.is_a?(Hash) && (v["title"] || v["image_urls"] || v["evaluation_status"]) }
    end

    unless evaluation.is_a?(Hash)
      Rails.logger.warn("UrlValidationService: unable to find evaluation payload in response: #{parsed.inspect}")
      return { error: "Invalid validation payload", body: parsed }
    end

    status = if validation_result.is_a?(Hash) && validation_result.key?("status")
               validation_result["status"].to_s.downcase == "success" ? "success" : "error"
             else
               parsed["success"] ? "success" : "error"
             end

    # Use string keys for data so downstream code can consistently access fields
    data = {
      "title" => evaluation["title"],
      "description" => evaluation["description"],
      "price" => evaluation["price"],
      "category" => evaluation["category"],
      "image_urls" => evaluation["image_urls"],
      "confidence" => evaluation["confidence"],
      "evaluation_status" => evaluation["evaluation_status"]
    }
    Rails.logger.debug("Parsed Validation Data: #{data.inspect}")

    return { error: "Validation failed", status: status } unless status.to_s.downcase == "success"

    # Require user to create auction
    unless @user
      puts "User not provided, skipping auction creation."
      return { success: true, validation: data }
    end

    ActiveRecord::Base.transaction do
      category_name = data["category"] || data["category_name"]
      category = Category.find_or_create_by!(name: category_name.presence || "Uncategorized")

      # Parse price and currency
      price_val = nil
      currency = "PLN"
      if data["price"].present?
        parts = data["price"].to_s.strip.split
        amount_str = parts[0] || "0"
        # normalize decimals
        amount_str = amount_str.tr(',', '.')
        begin
          price_val = BigDecimal(amount_str)
        rescue
          price_val = nil
        end
        currency_candidate = parts[1]&.upcase
        currency = %w[PLN EUR USD].include?(currency_candidate) ? currency_candidate : "PLN"
      end

      verification = case data["evaluation_status"].to_s.upcase
                     when "ORIGINAL"
                       "ai_verified"
                     else
                       "fake"
                     end

      auction = Auction.create!(
        title: data["title"] || "Untitled",
        description_text: data["description"] || nil,
        price: price_val,
        currency: currency,
        verification_status: verification,
        external_link: @auction_url,
        ai_score_authenticity: data["confidence"],
        submitted_by_user: @user,
        category: category
      )

      image_urls = Array(data["image_urls"]).map(&:to_s).map(&:strip).reject(&:blank?).uniq
      image_urls.each do |img_url|
        AuctionImage.create!(auction: auction, image_url: img_url)
      end

      { success: true, auction: auction }
    end
  rescue => e
    Rails.logger.error("UrlValidationService error: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}")
    { error: "Processing failed", message: e.message }
  end

  private

  def valid_url_format?
    uri = URI.parse(@auction_url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
