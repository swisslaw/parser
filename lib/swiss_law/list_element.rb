module SwissLaw
  class ListElement < Struct.new(:index, :content, :order)
    FORMAT = "%s. %s\n"
    INDENT = "  "
    def to_s
      INDENT * order + FORMAT % [index, content]
    end
    alias text to_s
  end
end
