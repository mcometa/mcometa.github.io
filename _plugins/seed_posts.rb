require 'rubygems'
require 'nokogiri'
require 'curb'
require 'yaml'

class Post
  TAGS = %w{ jekyll assets tutorial demo blog }

  attr_reader :date

  def initialize date
    @date = date
  end

  def text
    unless @text
      html = Nokogiri::HTML Curl.get("http://bluthipsum.com/").body_str
      @text = html.css("#main").text.gsub(/\r/, '')
    end

    @text
  end

  def reset!
    @text = nil
  end

  def title
    text.split(/\W+/).first(8).join(" ").sub(/\.*$/, '.')
  end

  def tags
    text.split(/\W+/).first(100).concat(TAGS)
      .map { |t| t.downcase }
      .select { |t| 2 < t.length }
      .uniq.shuffle.first(7)
  end

  def content
    YAML.dump({
      "layout"  => "post",
      "tags"    => tags,
      "title"   => title
    }) << "---\n\n" << text
  end

  def slug
    "#{date}-#{title}".downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
  end

  def filename
    "#{slug}.md"
  end

  def self.generate

  end
end


monthes = (1..12).to_a
days    = (1..29).to_a
titles  = []

42.times do
  post = Post.new("2012-#{"%02d" % monthes.sample}-#{"%02d" % days.sample}")

  # make sure title is unique
  post.reset! while titles.include? post.title.downcase
  titles << post.title.downcase

  puts post.filename
  File.open("_posts/#{post.filename}", "w"){ |io| io.puts post.content }
end