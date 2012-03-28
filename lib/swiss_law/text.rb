module SwissLaw
  class Text
    def initialize(element)
      @element ||= element
      @content ||= []
      @references ||= []
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
      @content << @references << Reference.new(child)
    end

    def text(child)
      @content << child.text.clean_without_strip
    end

    def a(child)
      # ignore
    end

    # not template-agnostic - uses __text__ for i
    def i(child)
      @content << '__' << child.text << '__'
    end

    def content
      @content.join('')
    end
  end
end
