$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))
require 'swiss_law'
DATA = File.expand_path('data', File.dirname(__FILE__))
RAW = File.expand_path('../www.admin.ch', File.dirname(__FILE__))
require 'find'
require 'minitest/spec'
require 'minitest/autorun'
require 'pry'

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
