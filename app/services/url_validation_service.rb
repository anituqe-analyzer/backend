class UrlValidationService
  include HTTParty

  base_uri "https://hatamo-antique-auth-api.hf.space"

  def initialize(auction_url)
    @auction_url = auction_url
  end

  def call
    return { error: "Invalid URL format" } unless valid_url_format?

    response = self.class.post("/validate_url", {
      body: { url: @auction_url },
      headers: { "Content-Type" => "application/x-www-form-urlencoded" }
    })

    puts "URL Validation Response: #{response.body}"

    if response.success?
      JSON.parse(response.body)
    else
      { error: "Validation service error", status: response.code, body: response.body }
    end
  rescue => e
    puts "Error during URL validation: #{e.message}"
    { error: "Service unavailable", message: e.message }
  end

  private

  def valid_url_format?
    uri = URI.parse(@auction_url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
