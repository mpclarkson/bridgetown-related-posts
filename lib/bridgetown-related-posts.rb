require "bridgetown"
require_relative "bridgetown-related-posts/builder"

Bridgetown.initializer :"bridgetown-related-posts" do |config|
  config.builder BridgetownRelatedPosts::Builder
end

module BridgetownRelatedPosts
  def self.config
    @config ||= Bridgetown::Configuration.new
  end

  def self.set_config(config)
    @config = config
  end
end