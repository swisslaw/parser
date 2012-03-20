require 'swiss_law/text'
require 'swiss_law/list_element'
module SwissLaw
  class Paragraph < Text
    def initialize(*args)
      @content = []
      super
    end

    def content
      @content.join
    end
    
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

    def dt(child)
      @current_le = ListElement.new
      @current_le.index = child.text[/\w+/]
    end

    def dd(child)
      @current_le.content = child.text
      @content << @current_le
    end
  end
end
