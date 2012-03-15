require 'swiss_law/text'
module SwissLaw
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
end
