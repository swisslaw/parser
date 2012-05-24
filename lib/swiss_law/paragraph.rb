require 'swiss_law/text'
require 'swiss_law/list_element'
require 'swiss_law/table'
module SwissLaw
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

    def dt(child)
      @current_le = ListElement.new
      @current_le.order = 1
      @current_le.index = child.text[/\w+/]
    end

    def dd(child)
      @current_le.content = child.text.clean
      @content << @current_le
    end

    # fix for testcase 196
    def tbody(child)
      @content << Table.new(child)
    end

    def i(child)
      text = child.text
      if md = text.match(/^\s*(\d+)\.(.*)/)
        @index = md[1]
        @content << md[2].clean
      else
        super
      end
    end
  end
end
