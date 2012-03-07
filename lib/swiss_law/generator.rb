module SwissLaw
  class Paragraph
    def to_textile
      out = ""
      index.empty? or out << index.to_s + ". "
      out << text
      out
    end
  end

  class Footnote
    def to_textile
      "fn%s. %s" % [index, text]
    end
  end

  class Article
    def to_textile
      out = "h1. %s\n\n" % [title] << paragraphs.map(&:to_textile).join("\n")
      unless footnotes.empty?
        out << "\n\n" << footnotes.map(&:to_textile).join("\n")
      end
      out << "\n"
    end
  end
end
