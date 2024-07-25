require "bridgetown"
require "bridgetown-related-posts/builder"

Bridgetown::PluginManager.new_source_manifest(
  origin: BridgetownRelatedPosts,
  components: {
    "builders" => [{
      name: "RelatedPosts",
      class: BridgetownRelatedPosts::Builder
    }]
  }
)