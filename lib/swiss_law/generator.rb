module SwissLaw
  class Paragraph
    def to_textile
      out = ""
      index and out << index.to_s + "."
      out << content
      out.sub(/\n$/, "")
    end
  end

  class Title
    def to_textile
      "h1. %s\n\n" % [content]
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
      cs = Text::COLLAPSING_SPACE
      out.gsub!(/#{cs}$/, '')
      out.gsub!(/#{cs} | #{cs}|#{cs}/, " ")
      out
    end
  end
end
