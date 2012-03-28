module SwissLaw
  class Reference
    def initialize(element)
      @element = element
    end

    def fn
      @element.xpath('.//a').first['href'].match(/#fn(\d+)/)[1]
    end

    def to_s
      "[#{fn}]"
    end
  end
end
