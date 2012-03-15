require 'swiss_law/text'
module SwissLaw
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
end
