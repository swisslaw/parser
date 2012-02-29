# encoding: utf-8
require 'nokogiri'
require 'pry'
require 'cgi'
Encoding.default_internal = Encoding.default_external = 'utf-8'

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
    @paragraph_footnotes ||= @parsed.xpath("//p[preceding::h5]").partition do |cand|
      cand['name'] =~ /fn/
    end.map do |paragraphs|
      paragraphs.map do |p|
        text = p.xpath("text()").to_s.strip.encode("utf-8")
        next if text.size < 2
        CGI.unescapeHTML(text.delete("\xc2\xa0"))
      end.compact
    end.reverse
  end

  def inspect
    "#<Law id=#{id}, article=#{article}, paragraphs=#{paragraphs.inspect}, footnotes=#{footnotes.inspect}>"
  end
end

class Parser
  def initialize(paths)
    @paths = paths
  end

  def parsed
    @parsed ||= @paths.each.with_object({}) do |file, keep|
      law = Law.new(file)
      keep[law.article] = law
    end
  end
end

class ConstitutionParser < Parser
  PATH = File.expand_path('../../www.admin.ch/ch/d/sr/101/*', __FILE__)
  def initialize
    super(Dir[PATH].select do |path|
      path =~ /a\d+\w{0,2}\.html/
    end)
  end
end

if $0 == __FILE__
  parser = ConstitutionParser.new
  puts parser.parsed.inspect
  binding.pry
end
