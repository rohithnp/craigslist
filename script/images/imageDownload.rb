URL = 'http://0.0.0.0:3000/brands'

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'

def make_absolute( href, root )
  URI.parse(root).merge(URI.parse(href)).to_s
end

Nokogiri::HTML(open(URL)).xpath("//img/@src").each do |src|
  puts src
  uri = make_absolute(src,URL)
  File.open(File.basename(uri),'wb'){ |f| f.write(open(uri).read) }
end