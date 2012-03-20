module SwissLaw
  class Text
    def insert_references(string)
      offset = 0
      @references.each do |ref|
        ins = "[#{ref.fn}]"
        if ref.index == 0
          ins << " "
        else
          ins.prepend(" ")
        end
        string[ref.index + offset, 0] = ins
        offset += ins.size
      end
      string
    end
  end
  
  class Paragraph
    def to_textile
      out = ""
      index and out << index.to_s + ". "
      out << insert_references(content)
      out.sub(/\n$/, "")
    end
  end

  class Title
    def to_textile
      "h1. %s\n\n" % [insert_references(content)]
    end
  end

  class Footnote
    def to_textile
      "fn%s. %s" % [index, content]
    end
  end
  
  class Article
    def to_textile
      out = title.to_textile << paragraphs.map(&:to_textile).join("\n")
      unless footnotes.empty?
        out << "\n\n" << footnotes.map(&:to_textile).join("\n")
      end
      out << "\n"
    end
  end
end
