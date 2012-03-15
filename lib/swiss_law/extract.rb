# encoding: utf-8
require 'nokogiri'
require 'cgi'
Encoding.default_internal = Encoding.default_external = 'utf-8'

class String
  def clean
    clean_without_strip.strip
  end

  def clean_without_strip
    CGI.unescapeHTML(self.delete("\xc2\xa0").delete("\r\n").gsub("  ", " "))
  end
end

class Array
  def children
    self
  end
end

module SwissLaw
  class Text
    def initialize(element)
      @element = element
      @content = ""
      @references = []
      @element.children.each do |child|
        send(child.name, child)
      end
    end

    attr :content

    def empty?
      content.size < 2
    end

    private
    def sup(child)
      @references << Reference.new(child, @content.size)
    end

    def text(child)
      @content << child.text.clean
    end

    def a(child)
      # ignore
    end

    def i(child)
      @content << '__' << child.text << '__'
    end
  end

  class Title < Text
    def b(child)
      if @first_b
        @content << child.text.clean
      end
      @first_b = true
    end

    def i(child)
      unless @content.empty?
        @content << child.text.clean
      end
    end
  end
  
  class Paragraph < Text
    def index
      @index
    end
    
    def sup(child)
      if link = child.xpath('./a').first and link['href']
        super
      elsif link
        @index = child.text
      else
        @content << child.text
      end
    end
  end

  class Footnote < Text
    def initialize(element)
      super
      @content.strip!
    end
    
    attr :index

    private
    def b(child)
      @content << child.text
    end

    def text(child)
      @content << child.text.clean_without_strip
    end

    def a(child)
      unless @index
        @index = child.text
      else
        @content << child.text.clean
      end
    end

    def br(child)
      # ignore, assume it's EOL
    end
  end

  class Reference
    def initialize(element, index)
      @element = element
      @index = index
    end

    attr :index

    def fn
      @element.xpath('.//a').first['href'].match(/#fn(\d+)/)[1]
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
      @parsed.xpath("//p[preceding::h5]") - footnotes_paragraph
    end

    def footnotes_paragraph
      @parsed.xpath("//div[@id='fns']//p[preceding::h5]")
    end

    def paragraphs
      paragraphs_elements.map {|element| Paragraph.new element}.reject {|element| element.empty?}
    end

    def footnotes
      footnotes_paragraph.xpath('./small').children.slice_before do |element|
        element.name == 'br'
      end.map do |element|
        Footnote.new element
      end.reject {|element| element.empty?}
    end

    def footnotes?
      !! @parsed.css('#fns')
    end

    def title_element
      @parsed.css('h5')
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
