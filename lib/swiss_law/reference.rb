module SwissLaw
  class Reference
    def initialize(element, index)
      @element = element
      @index = index
    end

    attr :index

    def fn
      @element.xpath('.//a').first['href'].match(/#fn(\d+)/)[1]
    end
  end
end
