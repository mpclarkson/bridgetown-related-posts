# bridgetown-related-posts.gemspec
Gem::Specification.new do |spec|
  spec.name        = "bridgetown-related-posts"
  spec.version     = "0.2.3"
  spec.summary     = "A Bridgetown plugin for automatically generating related posts based on cosine similarity."
  spec.description = "This plugin calculates and adds related posts to your Bridgetown site using TF-IDF and cosine similarity."
  spec.authors     = ["Matthew Clarkson"]
  spec.email       = "mpclarkson@gmail.com"
  spec.files       = Dir["lib/**/*"]
  spec.homepage    = "https://github.com/mpclarkson/bridgetown-related-posts"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.3.0"
  spec.metadata = {
    "source_code_uri" => "https://github.com/mpclarkson/bridgetown-related-posts",
    "homepage_uri" => "https://github.com/mpclarkson/bridgetown-related-posts"
  }
  spec.add_dependency "bridgetown", ">= 1.3.0", "< 3.0"
end