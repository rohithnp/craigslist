require 'rubygems'  
require 'nokogiri'  
require 'open-uri'  
require 'paint'
  
f = File.open("../tmp/test.xml")
url ="https://www.plasticjungle.com/buy-gift-cards"
doc = Nokogiri::XML(f)
puts doc
node1 = doc.xpath('.//DataResource').first
node1['dataResourceId'] = 'WAL_LOGO'

f.close

File.open('../tmp/output.xml','w') do |f|
  f.puts doc
end

