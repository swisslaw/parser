module SwissLaw
  class Text
    def initialize(element)
      @element ||= element
      @content ||= ""
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
end
