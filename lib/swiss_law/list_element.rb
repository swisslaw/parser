module SwissLaw
  class ListElement < Struct.new(:index, :content)
    FORMAT = "  %s. %s\n"
    def to_s
      FORMAT % [index, content]
    end
    alias text to_s
  end
end
