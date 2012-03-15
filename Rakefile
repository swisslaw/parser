$LOAD_PATH.unshift File.expand_path('test', File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'swiss_law'
RAW = File.expand_path('www.admin.ch', File.dirname(__FILE__))
GEN = File.expand_path('test/gen', File.dirname(__FILE__))
FileUtils.mkdir_p(GEN)

task(:test) do
  require 'total'
end

task(:gen) do
  coll = ENV['coll']
  gen = SwissLaw::Parser.new(RAW)
  Dir[RAW + "/**/101/**"].each do |file|
    _, lang, sr, article = *file.match(/\/(\w+)\/\w+\/(\w+)\/a(\w+)\.html/)
    begin
      dir = File.join(GEN, lang, sr)
      FileUtils.mkdir_p(dir)
      File.open(File.join(dir, article), 'w') do |out|
        out.write gen[lang, sr, article].to_textile
      end
    rescue => e
      puts e
    end
  end
end
