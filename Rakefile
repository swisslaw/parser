$LOAD_PATH.unshift File.expand_path('test', File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'swiss_law'
RAW = File.expand_path('www.admin.ch', File.dirname(__FILE__))
LAWS = File.expand_path('laws', File.dirname(__FILE__))

task(:test) do
  require 'total'
end

task(:gen) do
  coll = ENV['coll']
  gen = SwissLaw::Parser.new(RAW)
  Dir[RAW + "/**/101/**"].each do |file|
    _, lang, sr, article = *file.match(/\/(\w+)\/\w+\/(\w+)\/a(\d\w*)\.html/)
    next unless article
    begin
      dir = File.join(LAWS, lang, sr)
      FileUtils.mkdir_p(dir)
      File.open(File.join(dir, article), 'w') do |out|
        out.write gen[lang, sr, article].to_textile
      end
    rescue => e
      puts "lang: %s sr: %s art: %s error: %s" % [lang, sr, article, e]
    end
  end
end
