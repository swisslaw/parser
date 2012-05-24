require 'swiss_law/list_element'
module SwissLaw
  class TableElement < ListElement
    def initialize
      super
      self.content = []
      self.pre = []
    end

    def to_s
      (INDENT * order + "#{index}." + content.zip(pre).each(&:reverse!).flatten.join(Text::COLLAPSING_SPACE)).collapse_spaces!
    end

    attr_accessor :pre
  end
end
