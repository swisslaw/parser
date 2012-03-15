DATA = File.expand_path('data', File.dirname(__FILE__))
require 'minitest/spec'
require 'minitest/autorun'
require 'pry'
require 'find'

describe SwissLaw::Parser do
  gen = SwissLaw::Parser.new(RAW)
  Find.find DATA do |file|
    next unless File.file? file
    lang, sr, article = *file.split("/")[-3..-1]
    it "should generate sr:#{sr} article:#{article}" do
      gen[lang, sr, article].to_textile.must_equal File.read(file)
    end
  end
end
