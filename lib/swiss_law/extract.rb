# encoding: utf-8
require 'nokogiri'
require 'pry'
require 'cgi'
Encoding.default_internal = Encoding.default_external = 'utf-8'

module SwissLaw
  class Text
    def initialize(element)
      @element = element
    end

    attr :raw_text
    alias :text :raw_text

    def empty?
      @raw_text.size < 2
    end
  end

  class Paragraph < Text
    def initialize(element)
      super
      text = @element.xpath("text()").to_s.encode('utf-8').strip.delete("\xc2\xa0")
      @raw_text = CGI.unescapeHTML(text)
    end
    
    def index
      (a = @element.css('a')) && a.text
    end
  end

  class Footnote < Text
    def initialize(element)
      super
      @raw_text = @element.child.children[1..-1].text.strip.delete("\r\n").gsub("  ", " ")
    end

    def index
      (a = @element.css('a').first) && a.text
    end
  end

  class Article
    def initialize(file)
      @file = file
      @parsed = Nokogiri.HTML(File.open(file, 'r:iso-8859-1:utf-8'))
    end

    def index
      File.basename(@file, ".html")[1..-1]
    end

    def sr
      @file.split("/")[-2]
    end

    def paragraphs
      paragraph_footnotes.first
    end

    def footnotes
      paragraph_footnotes.last
    end

    def footnotes?
      !! @parsed.css('#fns')
    end

    def title
      @parsed.css('title').text.match(/.*Art..\d+\w* (.+) \(.*/)[1].strip
    end

    PFKLASSES = [Paragraph, Footnote]
    def paragraph_footnotes
      @paragraph_footnotes ||= @parsed.xpath("//p[preceding::h5]").partition do |cand|
        cand.xpath("ancestor::div[@id='fns']").empty?
      end.map.with_index do |paragraphs, index|
        paragraphs.map do |element|
          text = PFKLASSES[index].new(element)
          text.empty? ? nil : text
        end.compact
      end
    end

    def inspect
      "#<Law index=#{index}, sr=#{sr}, title=#{title}, paragraphs=#{paragraphs.inspect}, footnotes=#{footnotes.inspect}>"
    end
  end

  PATH = "ch/%s/sr/%s/a%s.html"
  class Parser
    class ArticleKey < Struct.new(:lang, :sr, :article)
    end
    
    def initialize(root)
      @root = root
      @parsed = Hash.new do |hash, key|
        path = path(key)
        hash[key] = Article.new(path)
      end
    end

    def path(key)
      File.expand_path(PATH % [*key], @root)
    end
    
    def [](lang, sr, article)
      @parsed[ArticleKey.new(lang, sr, article)]
    end

    # this should return all parsing results
    def parsed
      raise NotImplementedError
    end
  end
end
