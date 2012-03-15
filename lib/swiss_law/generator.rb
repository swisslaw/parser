module SwissLaw
  class Text
    def insert_references(string)
      @references.each do |ref|
        string[ref.index, 0] = "[#{ref.fn}] "
      end
      string
    end
  end
  
  class Paragraph
    def to_textile
      out = ""
      index and out << index.to_s + ". "
      out << insert_references(content)
      out
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
