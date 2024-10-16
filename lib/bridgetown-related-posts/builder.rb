# lib/bridgetown-related-posts/builder.rb
module BridgetownRelatedPosts
  class Builder < Bridgetown::Builder

    def self.init
      config.related_posts_limit ||= 5 # Default value
    end
   
    def build
      hook :site, :post_read do
        BridgetownRelatedPosts.set_config(config)
        posts_data = prepare_posts_data
        if posts_data.empty?
          Bridgetown.logger.warn "Bridgetown Related Posts:", "No posts found for RelatedPostsBuilder"
        else
          similarity_matrix = calculate_similarity(posts_data)
          add_related_posts(posts_data, similarity_matrix)
        end
      end
    end
  
    def prepare_posts_data
      verbose = config.related_posts&.verbose
      posts = site.collections["posts"].resources
      Bridgetown.logger.info "Bridgetown Related Posts:", "Generating related posts"
      Bridgetown.logger.info "Number of posts found: #{posts.size}" if verbose
    
      posts.map do |post|
        begin
          content = post.content
          
          {
            relative_path: post.relative_path,
            title: post.data["title"] || "Untitled",
            content: content || "",
          }
        rescue => e
          Bridgetown.logger.error "Error processing post #{post.relative_path}: #{e.message}"
          Bridgetown.logger.error "Post data: #{post.data.inspect}"
          nil
        end
      end.compact
    end
  
    def calculate_similarity(posts_data)
      idf = compute_idf(posts_data)
      tfidf_vectors = posts_data.map { |post| compute_tfidf(post[:content], idf) }
      
      similarity_matrix = {}
      posts_data.each_with_index do |post, i|
        similarity_matrix[post[:relative_path]] = {}
        posts_data.each_with_index do |other_post, j|
          next if i == j
          similarity = cosine_similarity(tfidf_vectors[i], tfidf_vectors[j])
          similarity_matrix[post[:relative_path]][other_post[:relative_path]] = similarity
        end
      end
      similarity_matrix
    end
  
    def compute_idf(posts_data)
      document_frequency = Hash.new(0)
      posts_data.each do |post|
        words = post[:content].downcase.split.uniq
        words.each { |word| document_frequency[word] += 1 }
      end
  
      idf = {}
      total_docs = posts_data.size
      document_frequency.each do |word, freq|
        idf[word] = Math.log(total_docs.to_f / (freq + 1))
      end
      idf
    end
  
    def compute_tfidf(text, idf)
      words = text.downcase.split
      word_count = words.size
      tf = Hash.new(0)
      words.each { |word| tf[word] += 1 }
      
      tfidf = {}
      tf.each do |word, freq|
        tfidf[word] = (freq.to_f / word_count) * (idf[word] || 0)
      end
      tfidf
    end
  
    def cosine_similarity(vec1, vec2)
      dot_product = 0
      vec1.each_key do |key|
        dot_product += vec1[key] * vec2[key] if vec2.has_key?(key)
      end
  
      mag1 = Math.sqrt(vec1.values.map { |x| x ** 2 }.sum)
      mag2 = Math.sqrt(vec2.values.map { |x| x ** 2 }.sum)
  
      dot_product / (mag1 * mag2)
    end
  
    def add_related_posts(posts_data, similarity_matrix)
      limit = config.related_posts&.limit || 5
      verbose = config.related_posts&.verbose
      
      posts_data.each do |post|
        similar_posts = similarity_matrix[post[:relative_path]]
        if similar_posts.nil?
          Bridgetown.logger.warning "No similar posts found for: #{post[:relative_path]}"
          next
        end

        similar_posts = similar_posts
          .sort_by { |_, score| -score }
          .first(limit)
          .map { |relative_path, _| site.collections["posts"].resources.find { |p| p.relative_path == relative_path } }
          .compact
    
        # Find the actual post object
        actual_post = site.collections["posts"].resources.find { |p| p.relative_path == post[:relative_path] }
    
        if actual_post
          # Add related posts to the post's data
          actual_post.data["related_posts"] = similar_posts
    
          Bridgetown.logger.info "Related posts for #{actual_post.data["title"]}:" if verbose
    
          similar_posts.each do |related_post|
            if related_post
              Bridgetown.logger.info "  - #{related_post.data["title"]}" if verbose
            else
              Bridgetown.logger.warning "  - Related post not found"
            end
          end
        else
          Bridgetown.logger.error "Post not found: #{post[:relative_path]}"
        end
      end
    end
  end
end
