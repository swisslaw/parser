require 'swiss_law/core_ext'
module SwissLaw
  class Paragraph
    def to_textile
      out = ""
      index and out << index.to_s + ". "
      out << content
      out.sub(/\n$/, "")
      out.collapse_spaces!
    end
  end

  class Title
    def to_textile
      ("h1. %s\n\n" % [content]).collapse_spaces!
    end
  end

  class Footnote
    def to_textile
      ("fn%s. %s" % [index, content]).collapse_spaces!
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
