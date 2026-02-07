# Clear existing data (only in development)
if Rails.env.development?
  puts 'Clearing existing data...'
  OpinionVote.destroy_all
  Opinion.destroy_all
  AiAnalysisHistory.destroy_all
  Auction.destroy_all
  UserExpertCategory.destroy_all
  Category.destroy_all
  User.destroy_all
  puts '✓ Data cleared'
end

puts "\n🌱 Seeding database..."

# === USERS ===
puts "\n👥 Creating users..."
admin = User.find_or_create_by!(username: 'admin') do |user|
  user.email = 'admin@example.com'
  user.password = 'password123'
  user.role = 'admin'
end
puts "  ✓ Admin: #{admin.username}"

expert_furniture = User.find_or_create_by!(username: 'expert_furniture') do |user|
  user.email = 'expert.furniture@example.com'
  user.password = 'password123'
  user.role = 'expert'
end
puts "  ✓ Expert (Furniture): #{expert_furniture.username}"

expert_ceramics = User.find_or_create_by!(username: 'expert_ceramics') do |user|
  user.email = 'expert.ceramics@example.com'
  user.password = 'password123'
  user.role = 'expert'
end
puts "  ✓ Expert (Ceramics): #{expert_ceramics.username}"

regular_user = User.find_or_create_by!(username: 'john_doe') do |user|
  user.email = 'john@example.com'
  user.password = 'password123'
  user.role = 'user'
end
puts "  ✓ Regular user: #{regular_user.username}"

# === CATEGORIES ===
puts "\n📁 Creating categories..."
furniture = Category.find_or_create_by!(name: 'Furniture') do |category|
  category.description = 'Antique furniture and interior furnishings'
end
puts "  ✓ #{furniture.name}"

furniture_baroque = Category.find_or_create_by!(name: 'Baroque Furniture') do |category|
  category.description = 'Furniture from the Baroque period'
  category.parent = furniture
end
puts "    ✓ #{furniture_baroque.name} (subcategory)"

ceramics = Category.find_or_create_by!(name: 'Ceramics') do |category|
  category.description = 'Porcelain, faience and other ceramic products'
end
puts "  ✓ #{ceramics.name}"

paintings = Category.find_or_create_by!(name: 'Paintings') do |category|
  category.description = 'Paintings and prints'
end
puts "  ✓ #{paintings.name}"

jewelry = Category.find_or_create_by!(name: 'Jewelry') do |category|
  category.description = 'Antique jewelry and watches'
end
puts "  ✓ #{jewelry.name}"

# === EXPERT CATEGORIES ===
puts "\n🎓 Assigning expert categories..."
UserExpertCategory.find_or_create_by!(user: expert_furniture, category: furniture)
UserExpertCategory.find_or_create_by!(user: expert_furniture, category: furniture_baroque)
puts "  ✓ #{expert_furniture.username} -> Furniture"

UserExpertCategory.find_or_create_by!(user: expert_ceramics, category: ceramics)
puts "  ✓ #{expert_ceramics.username} -> Ceramics"

# === AUCTIONS ===
puts "\n🏺 Creating auctions..."

auction1 = Auction.find_or_create_by!(title: '18th Century Baroque Armchair') do |auction|
  auction.submitted_by_user = regular_user
  auction.description_text = 'Beautiful Baroque period armchair, oak wood, silk upholstery. Very good condition.'
  auction.price = 3500.00
  auction.currency = 'USD'
  auction.category = furniture_baroque
  auction.verification_status = 'pending'
  auction.external_link = 'https://example.com/auction1'
end
puts "  ✓ #{auction1.title}"

auction2 = Auction.find_or_create_by!(title: 'Meissen Porcelain Coffee Set') do |auction|
  auction.submitted_by_user = regular_user
  auction.description_text = 'Complete coffee set for 6 people, signed Meissen, 19th century.'
  auction.price = 2800.00
  auction.currency = 'USD'
  auction.category = ceramics
  auction.verification_status = 'ai_verified'
  auction.ai_score_authenticity = 0.87
  auction.external_link = 'https://example.com/auction2'
end
puts "  ✓ #{auction2.title}"

auction3 = Auction.find_or_create_by!(title: 'Oil Painting - Landscape') do |auction|
  auction.submitted_by_user = admin
  auction.description_text = 'Mountain landscape, oil technique, signed, circa 1920.'
  auction.price = 1500.00
  auction.currency = 'USD'
  auction.category = paintings
  auction.verification_status = 'expert_verified'
end
puts "  ✓ #{auction3.title}"

auction4 = Auction.find_or_create_by!(title: 'Gold Pocket Watch') do |auction|
  auction.submitted_by_user = regular_user
  auction.description_text = 'Pocket watch, 14k gold, working mechanism.'
  auction.price = 4200.00
  auction.currency = 'USD'
  auction.category = jewelry
  auction.verification_status = 'disputed'
end
puts "  ✓ #{auction4.title}"

auction5 = Auction.find_or_create_by!(title: 'Louis XV Style Chest of Drawers') do |auction|
  auction.submitted_by_user = regular_user
  auction.description_text = 'Chest of drawers in Louis XV style, walnut veneer.'
  auction.price = 2100.00
  auction.currency = 'USD'
  auction.category = furniture
  auction.verification_status = 'fake'
  auction.ai_score_authenticity = 0.23
  auction.ai_uncertainty_message = 'Modern materials detected'
end
puts "  ✓ #{auction5.title}"

# === OPINIONS ===
puts "\n💬 Creating opinions..."

opinion1 = Opinion.find_or_create_by!(auction: auction1, user: expert_furniture) do |opinion|
  opinion.author_type = 'expert'
  opinion.verdict = 'authentic'
  opinion.content = 'After analyzing the construction details and decorative style, I confirm authenticity. The armchair dates from the 18th century, southern European origin.'
end
puts "  ✓ Opinion by #{expert_furniture.username} on '#{auction1.title}'"

opinion2 = Opinion.find_or_create_by!(auction: auction2, user: expert_ceramics) do |opinion|
  opinion.author_type = 'expert'
  opinion.verdict = 'authentic'
  opinion.content = 'The Meissen signature is authentic, porcelain quality corresponds to 19th century production period.'
end
puts "  ✓ Opinion by #{expert_ceramics.username} on '#{auction2.title}'"

opinion3 = Opinion.find_or_create_by!(auction: auction4, user: regular_user) do |opinion|
  opinion.author_type = 'user'
  opinion.verdict = 'unsure'
  opinion.content = 'The watch looks authentic, but lack of documentation raises concerns.'
end
puts "  ✓ Opinion by #{regular_user.username} on '#{auction4.title}'"

opinion4 = Opinion.find_or_create_by!(auction: auction5, user: expert_furniture) do |opinion|
  opinion.author_type = 'expert'
  opinion.verdict = 'fake'
  opinion.content = 'This chest is a modern replica. Modern adhesives and varnishes were used.'
end
puts "  ✓ Opinion by #{expert_furniture.username} on '#{auction5.title}'"

# === OPINION VOTES ===
puts "\n👍 Creating opinion votes..."

OpinionVote.find_or_create_by!(opinion: opinion1, user: regular_user, vote_type: 1)
OpinionVote.find_or_create_by!(opinion: opinion1, user: admin, vote_type: 1)
puts "  ✓ 2 upvotes for opinion on '#{auction1.title}'"

OpinionVote.find_or_create_by!(opinion: opinion2, user: regular_user, vote_type: 1)
puts "  ✓ 1 upvote for opinion on '#{auction2.title}'"

OpinionVote.find_or_create_by!(opinion: opinion4, user: regular_user, vote_type: 1)
OpinionVote.find_or_create_by!(opinion: opinion4, user: admin, vote_type: 1)
puts "  ✓ 2 upvotes for opinion on '#{auction5.title}'"

# === AI ANALYSIS HISTORY ===
puts "\n🤖 Creating AI analysis history..."

AiAnalysisHistory.find_or_create_by!(auction: auction2, model_version: 'gpt-4-vision-1.0') do |analysis|
  analysis.ai_score_authenticity = 0.87
  analysis.ai_decision = 'authentic'
  analysis.ai_raw_result = {
    confidence: 0.87,
    detected_features: %w[porcelain_quality signature_match period_style],
    warnings: []
  }
  analysis.message = 'High confidence in authenticity based on visual analysis'
end
puts "  ✓ AI analysis for '#{auction2.title}'"

AiAnalysisHistory.find_or_create_by!(auction: auction5, model_version: 'gpt-4-vision-1.0') do |analysis|
  analysis.ai_score_authenticity = 0.23
  analysis.ai_decision = 'fake'
  analysis.ai_raw_result = {
    confidence: 0.77,
    detected_features: %w[modern_materials incorrect_joinery],
    warnings: ['Modern adhesives detected', 'Anachronistic hardware']
  }
  analysis.message = 'Low authenticity score - modern materials detected'
end
puts "  ✓ AI analysis for '#{auction5.title}'"

puts "\n✅ Seeding completed!"
puts "\n📊 Summary:"
puts "  Users: #{User.count}"
puts "  Categories: #{Category.count}"
puts "  Auctions: #{Auction.count}"
puts "  Opinions: #{Opinion.count}"
puts "  Opinion Votes: #{OpinionVote.count}"
puts "  AI Analyses: #{AiAnalysisHistory.count}"
puts "\n🚀 Ready to test! Run: rails console"
