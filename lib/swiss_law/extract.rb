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
    
    def references
      @element.xpath("//a[contains(@href, 'fn')]")
    end

    def empty?
      text.size < 2
    end
  end

  class Paragraph < Text
    def initialize(element)
      super
    end

    def text
      CGI.unescapeHTML(@element.xpath("text()").to_s.encode('utf-8').strip.delete("\xc2\xa0"))
    end
    
    def index
      (a = @element.css('a')) && a.text
    end
  end

  class Footnote < Text
    def initialize(element)
      super
    end

    def text
      @element.child.children[1..-1].text.strip.delete("\r\n").gsub("  ", " ")
    end

    def index
      (a = @element.css('a').first) && a.text
    end
  end

  class Title < Text
    def initialize(element)
      super
    end

    def text
      @element.text.match(/.*Art..\d+\w* (.+) \(.*/)[1].strip
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

    def paragraphs_elements
      @parsed.xpath("//p[preceding::h5]") - footnotes_elements
    end

    def footnotes_elements
      @parsed.xpath("//div[@id='fns']//p[preceding::h5]")
    end

    def paragraphs
      paragraphs_elements.map {|element| Paragraph.new element}.reject {|element| element.empty?}
    end

    def footnotes
      footnotes_elements.map {|element| Footnote.new element}.reject {|element| element.empty?}
    end

    def footnotes?
      !! @parsed.css('#fns')
    end

    def title_element
      @parsed.css('title')
    end

    def title
      Title.new(title_element)
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
