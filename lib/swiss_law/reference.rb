module SwissLaw
  class Reference
    def initialize(element)
      @element = element
    end

    def fn
      @element.xpath('.//a').first['href'].match(/#fn(\d+)/)[1]
    end

    def to_s
      Text::COLLAPSING_SPACE + "[#{fn}]" + Text::COLLAPSING_SPACE
    end
  end
end
