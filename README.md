# Bridgetown Related Posts

A Bridgetown plugin that automatically generates and adds related posts to your Bridgetown site using TF-IDF and cosine similarity.

## Installation

Add this line to your Bridgetown site's Gemfile:

```ruby
gem 'bridgetown-related-posts'
```

And then execute:

`$ bundle install`

## Usage

After installing the gem, add the following to your `config/initializers.rb`:

```ruby
init :"bridgetown-related-posts"
```

## Configuration

You can configure the number of related posts to display in your `bridgetown.config.yml`:

```yaml
related_posts:
  limit: 3  # Change this to your desired number
```  

This will automatically add related posts to each post in your Bridgetown site.

If not configured, the default number of related posts is 5.

## How It Works

This plugin uses the TF-IDF (Term Frequency-Inverse Document Frequency) algorithm and cosine similarity to find related posts. Here's a brief overview of the process:

- It analyzes the content of all posts in your site.
- It calculates the TF-IDF scores for each word in each post.
- It computes the cosine similarity between posts based on their TF-IDF vectors.
- It selects the top N most similar posts for each post, where N is the configured number of related posts.

## Displaying Related Posts

To display related posts in your templates, you can use the related_posts attribute that this plugin adds to each post. For example, in your post layout:

```liquid
{% if resource.related_posts %}
  <h2>Related Posts</h2>
  <ul>
    {% for related_post in resource.related_posts %}
      <li><a href="{{ related_post.relative_url }}">{{ related_post.title }}</a></li>
    {% endfor %}
  </ul>
{% endif %}
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/mpclarkson/bridgetown-related-posts.

## License

The gem is available as open source under the terms of the MIT License.

## Requirements

- Ruby >= 3.3.0
- Bridgetown >= 1.3.0, < 2.0

## Sponsor

This gem is sponsored by [Osher Digital](http://osher.com.au/).