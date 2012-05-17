# encoding: utf-8
class String
  def clean
    clean_without_strip.strip
  end

  def clean_without_strip
    CGI.unescapeHTML(self.gsub("\xc2\xa0", " ").delete("\r\n").gsub("  ", " "))
  end

  def collapse_spaces!
    cs = SwissLaw::Text::COLLAPSING_SPACE
    gsub!(/#{cs}$/, '')
    gsub!(/#{cs} | #{cs}|#{cs}/, " ")
    self
  end
end

class Array
  def children
    self
  end
end
