require 'nokogiri'
require 'pathname'
PATH = 'www.admin.ch/ch/d/sr/101/*'

class Law
  def initialize(file)
    @file = file
    @parsed = Nokogiri.HTML(File.open(file, 'r:iso-8859-1'))
  end

  def article
    @article ||= File.basename(@file, ".html")[1..-1]
  end

  def id
    @id ||= @file.split("/")[-2]
  end

  def paragraphs
    @paragraphs ||= paragraph_footnotes.first
  end

  def footnotes
    @footnotes ||= paragraph_footnotes.last
  end

  def paragraph_footnotes
    @paragraph_footnotes ||= @parsed.xpath("//p[preceding::h5]").reject do |cand|
      cand.inner_text.size < 5
    end.partition do |cand|
      cand['name'] =~ /fn/
    end.map do |paragraphs|
      paragraphs.map {|p| p.xpath("text()").to_s.strip.force_encoding("utf-8") }
    end.reverse
  end
end

result = Dir[PATH].map do |file|
  next unless file =~ /a\d+\w{0,2}\.html/
  Law.new(file)
end.compact

result.each do |res|
  puts res.paragraphs
end

