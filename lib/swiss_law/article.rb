# encoding: utf-8
require 'swiss_law/paragraph'
require 'swiss_law/footnote'
require 'swiss_law/title'
require 'swiss_law/reference'
require 'swiss_law/core_ext'

module SwissLaw
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
      @parsed.xpath("//div[@id='spalteContentPlus']/*[preceding::h5 and following::hr and not(preceding::hr)]")
    end

    def footnotes_elements
      @parsed.xpath("//div[@id='fns']//p[preceding::h5]/small")
    end

    def paragraphs
      paragraphs_elements.map {|element| Paragraph.new element}.reject {|element| element.empty?}
    end

    def footnotes
      footnotes_elements.children.slice_before do |element|
        element.name == 'br'
      end.map do |element|
        Footnote.new element
      end.reject(&:empty?)
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
end
