# encoding: utf-8
class String
  def clean
    clean_without_strip.strip
  end

  def clean_without_strip
    CGI.unescapeHTML(self.delete("\xc2\xa0").delete("\r\n").gsub("  ", " "))
  end
end

class Array
  def children
    self
  end
end