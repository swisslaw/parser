# -*- coding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'nokogiri'
require 'pry'

TABLE = Nokogiri::HTML.parse <<TBL
<table cellpadding="5" border="1" width="100%" class="kavTable"><tbody><tr><td width="3%"></td><td width="6%">
<p>a.</p></td><td width="90%">
<p>für Lastwagen und Sattelmotorfahrzeuge von</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%"></td><td width="29%"></td><td width="55%">
<p>Fr.</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 3,5 bis 12 t</p></td><td width="55%">
<p>&nbsp;&nbsp;650</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 12 bis 18 t</p></td><td width="55%">
<p>2000</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 18 bis 26 t</p></td><td width="55%">
<p>3000</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 26 t</p></td><td width="55%">
<p>4000</p></td></tr><tr><td width="3%"></td><td width="6%">
<p>b.</p></td><td width="90%">
<p>für Anhänger von</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 3,5 bis 8 t</p></td><td width="55%">
<p>&nbsp;&nbsp;650</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 8 bis 10 t</p></td><td width="55%">
<p>1500</p></td></tr><tr><td width="3%"></td><td width="6%"></td><td width="5%">
<p>–</p></td><td width="29%">
<p>über 10 t</p></td><td width="55%">
<p>2000</p></td></tr><tr><td width="3%"></td><td width="6%">
<p>c.</p></td><td width="35%">
<p>für Gesellschaftswagen</p></td><td width="55%">
<p>&nbsp;&nbsp;650</p></td></tr></tbody></table>
TBL

OUT = <<OUT
  a. für Lastwagen und Sattelmotorfahrzeuge von
    1. über 3,5 bis 12 t Fr. 650
    2. über 12 bis 18 t Fr. 2000
    3. über 18 bis 26 t Fr. 3000
    4. über 26 t Fr. 4000
  b. für Anhänger von
    1. über 3,5 bis 8 t Fr. 650
    2. über 8 bis 10 t Fr. 1500
    3. über 10 t Fr. 2000
  c. für Gesellschaftswagen Fr. 650
OUT

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'swiss_law/table'

describe SwissLaw::Table do
  it "should generate a196 correctly" do
    tbody = TABLE.css('tbody').first
    SwissLaw::Table.new(tbody).to_s.must_equal OUT.rstrip
  end
end
