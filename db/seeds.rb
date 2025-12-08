# Clear existing data (only in development)
if Rails.env.development?
  puts "Clearing existing data..."
  OpinionVote.destroy_all
  Opinion.destroy_all
  AiAnalysisHistory.destroy_all
  Auction.destroy_all
  UserExpertCategory.destroy_all
  Category.destroy_all
  User.destroy_all
  puts "✓ Data cleared"
end

puts "\n🌱 Seeding database..."

# === USERS ===
puts "\n👥 Creating users..."
admin = User.create!(
  username: "admin",
  email: "admin@example.com",
  password: "password123",
  role: "admin"
)
puts "  ✓ Admin: #{admin.username}"

expert_furniture = User.create!(
  username: "expert_furniture",
  email: "expert.furniture@example.com",
  password: "password123",
  role: "expert"
)
puts "  ✓ Expert (Furniture): #{expert_furniture.username}"

expert_ceramics = User.create!(
  username: "expert_ceramics",
  email: "expert.ceramics@example.com",
  password: "password123",
  role: "expert"
)
puts "  ✓ Expert (Ceramics): #{expert_ceramics.username}"

regular_user = User.create!(
  username: "john_doe",
  email: "john@example.com",
  password: "password123",
  role: "user"
)
puts "  ✓ Regular user: #{regular_user.username}"

# === CATEGORIES ===
puts "\n📁 Creating categories..."
furniture = Category.create!(
  name: "Furniture",
  description: "Antique furniture and interior furnishings"
)
puts "  ✓ #{furniture.name}"

furniture_baroque = Category.create!(
  name: "Baroque Furniture",
  description: "Furniture from the Baroque period",
  parent: furniture
)
puts "    ✓ #{furniture_baroque.name} (subcategory)"

ceramics = Category.create!(
  name: "Ceramics",
  description: "Porcelain, faience and other ceramic products"
)
puts "  ✓ #{ceramics.name}"

paintings = Category.create!(
  name: "Paintings",
  description: "Paintings and prints"
)
puts "  ✓ #{paintings.name}"

jewelry = Category.create!(
  name: "Jewelry",
  description: "Antique jewelry and watches"
)
puts "  ✓ #{jewelry.name}"

# === EXPERT CATEGORIES ===
puts "\n🎓 Assigning expert categories..."
expert_furniture.expert_categories << furniture
expert_furniture.expert_categories << furniture_baroque
puts "  ✓ #{expert_furniture.username} -> Furniture"

expert_ceramics.expert_categories << ceramics
puts "  ✓ #{expert_ceramics.username} -> Ceramics"

# === AUCTIONS ===
puts "\n🏺 Creating auctions..."

auction1 = regular_user.auctions.create!(
  title: "18th Century Baroque Armchair",
  description_text: "Beautiful Baroque period armchair, oak wood, silk upholstery. Very good condition.",
  price: 3500.00,
  currency: "USD",
  category: furniture_baroque,
  verification_status: "pending",
  external_link: "https://example.com/auction1"
)
puts "  ✓ #{auction1.title}"

auction2 = regular_user.auctions.create!(
  title: "Meissen Porcelain Coffee Set",
  description_text: "Complete coffee set for 6 people, signed Meissen, 19th century.",
  price: 2800.00,
  currency: "USD",
  category: ceramics,
  verification_status: "ai_verified",
  ai_score_authenticity: 0.87,
  external_link: "https://example.com/auction2"
)
puts "  ✓ #{auction2.title}"

auction3 = admin.auctions.create!(
  title: "Oil Painting - Landscape",
  description_text: "Mountain landscape, oil technique, signed, circa 1920.",
  price: 1500.00,
  currency: "USD",
  category: paintings,
  verification_status: "expert_verified"
)
puts "  ✓ #{auction3.title}"

auction4 = regular_user.auctions.create!(
  title: "Gold Pocket Watch",
  description_text: "Pocket watch, 14k gold, working mechanism.",
  price: 4200.00,
  currency: "USD",
  category: jewelry,
  verification_status: "disputed"
)
puts "  ✓ #{auction4.title}"

auction5 = regular_user.auctions.create!(
  title: "Louis XV Style Chest of Drawers",
  description_text: "Chest of drawers in Louis XV style, walnut veneer.",
  price: 2100.00,
  currency: "USD",
  category: furniture,
  verification_status: "fake",
  ai_score_authenticity: 0.23,
  ai_uncertainty_message: "Modern materials detected"
)
puts "  ✓ #{auction5.title}"

# === OPINIONS ===
puts "\n💬 Creating opinions..."

opinion1 = auction1.opinions.create!(
  user: expert_furniture,
  author_type: "expert",
  verdict: "authentic",
  content: "After analyzing the construction details and decorative style, I confirm authenticity. The armchair dates from the 18th century, southern European origin."
)
puts "  ✓ Opinion by #{expert_furniture.username} on '#{auction1.title}'"

opinion2 = auction2.opinions.create!(
  user: expert_ceramics,
  author_type: "expert",
  verdict: "authentic",
  content: "The Meissen signature is authentic, porcelain quality corresponds to 19th century production period."
)
puts "  ✓ Opinion by #{expert_ceramics.username} on '#{auction2.title}'"

opinion3 = auction4.opinions.create!(
  user: regular_user,
  author_type: "user",
  verdict: "unsure",
  content: "The watch looks authentic, but lack of documentation raises concerns."
)
puts "  ✓ Opinion by #{regular_user.username} on '#{auction4.title}'"

opinion4 = auction5.opinions.create!(
  user: expert_furniture,
  author_type: "expert",
  verdict: "fake",
  content: "This chest is a modern replica. Modern adhesives and varnishes were used."
)
puts "  ✓ Opinion by #{expert_furniture.username} on '#{auction5.title}'"

# === OPINION VOTES ===
puts "\n👍 Creating opinion votes..."

OpinionVote.create!(opinion: opinion1, user: regular_user, vote_type: 1)
OpinionVote.create!(opinion: opinion1, user: admin, vote_type: 1)
puts "  ✓ 2 upvotes for opinion on '#{auction1.title}'"

OpinionVote.create!(opinion: opinion2, user: regular_user, vote_type: 1)
puts "  ✓ 1 upvote for opinion on '#{auction2.title}'"

OpinionVote.create!(opinion: opinion4, user: regular_user, vote_type: 1)
OpinionVote.create!(opinion: opinion4, user: admin, vote_type: 1)
puts "  ✓ 2 upvotes for opinion on '#{auction5.title}'"

# === AI ANALYSIS HISTORY ===
puts "\n🤖 Creating AI analysis history..."

AiAnalysisHistory.create!(
  auction: auction2,
  model_version: "gpt-4-vision-1.0",
  ai_score_authenticity: 0.87,
  ai_decision: "authentic",
  ai_raw_result: {
    confidence: 0.87,
    detected_features: [ "porcelain_quality", "signature_match", "period_style" ],
    warnings: []
  },
  message: "High confidence in authenticity based on visual analysis"
)
puts "  ✓ AI analysis for '#{auction2.title}'"

AiAnalysisHistory.create!(
  auction: auction5,
  model_version: "gpt-4-vision-1.0",
  ai_score_authenticity: 0.23,
  ai_decision: "fake",
  ai_raw_result: {
    confidence: 0.77,
    detected_features: [ "modern_materials", "incorrect_joinery" ],
    warnings: [ "Modern adhesives detected", "Anachronistic hardware" ]
  },
  message: "Low authenticity score - modern materials detected"
)
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
