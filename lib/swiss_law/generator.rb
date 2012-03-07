module SwissLaw
  class Paragraph
    def to_textile
      "%s. %s" % [index, text]
    end
  end

  class Footnote
    def to_textile
      "fn%s. %s" % [index, text]
    end
  end

  class Article
    def to_textile
      "h1. %s\n\n" % [title] + paragraphs.map(&:to_textile).join("\n") + footnotes.map(&:to_textile).join("\n")
    end
  end
end
