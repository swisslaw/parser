# encoding: utf-8
require 'nokogiri'
require 'cgi'
require 'swiss_law/article'
module SwissLaw
  PATH = "ch/%s/sr/%s/a%s.html"
  class Parser
    class ArticleKey < Struct.new(:lang, :sr, :article)
    end
    
    def initialize(root)
      @root = root
      @parsed = Hash.new do |hash, key|
        path = path(key)
        hash[key] = Article.new(path)
      end
    end

    def path(key)
      File.expand_path(PATH % [*key], @root)
    end
    
    def [](lang, sr, article)
      @parsed[ArticleKey.new(lang, sr, article)]
    end

    # this should return all parsing results
    def parsed
      raise NotImplementedError
    end
  end
end
