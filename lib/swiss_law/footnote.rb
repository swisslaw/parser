# -*- coding: utf-8 -*-
require 'swiss_law/text'
module SwissLaw
  class Footnote < Text
    attr :index

    def content
      super.strip
    end

    def interesting?
      ! @text =~ /^Angenommen|^Aufgehoben|^Mit Übergangsbestimmung/
    end

    private
    def b(child)
      @content << child.text
    end

    def text(child)
      @content << child.text.clean_without_strip
    end

    def sup(child)
      # footnotes in footnotes?
    end

    def a(child)
      unless @index
        @index = child.text
      else
        @content << child.text.clean
      end
    end

    def br(child)
      # ignore, assume it's EOL
    end
  end
end
