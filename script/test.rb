require 'rubygems'  
require 'nokogiri'  
require 'open-uri'  
require 'paint'
  
url ="http://www.craigslist.org/about/sites"
doc = Nokogiri::HTML(open(url))  
us = doc.css(".colmask")[0]
city_links = us.css("a")

retailers=["best+buy","home+depot","lowes","target","walmart"]
#retailer ="home+depot"

retailers.each do |retailer|
	search_url = "/search/sss?query="+retailer+"+gift+card&srchType=T&minAsk=&maxAsk="
	@data = []
	city_links[1..-1].each do |city|
			#puts city["href"].to_s+search_url
			begin
				results = Nokogiri::HTML(open(city["href"].to_s+search_url))

				rescue OpenURI::HTTPError, Timeout::Error
					puts Paint["bad link --- " + city["href"].to_s+search_url,:red]
					next
			end
			#if results.css_at("row") == true then
				if results.css(".row").size == 0 then
					#puts city["href"].to_s+" ---- "+"NO"
				else
					results.css(".row").each do |row|
						value = row.css("a")[0].text[/\$[0-9\.]+/]
						price = row.css(".itempp").text[/[0-9][0-9\.]+/]
						if value.nil? == false and !price.nil? and value[1..-1].to_f >= price.to_f then
							total = total + value[1..-1]
							@data << (value[1..-1].to_f - price.to_f) / value[1..-1].to_f
							print Paint[@data.inject(:+).to_f / @data.size.to_f,:green]
							print "\r"
							STDOUT.flush
							#puts retailer
							#puts city["href"].to_s+" ---- "+value.to_s+" ===== "+price.to_s
						end
					end
				end
				#puts city["href"].to_s+" ---- "+results.css("row")[0].text
				#each do | title |
				#	puts title.css_at("a").text
				#end
			#else
			#	puts "no results"
			#end
	end
	puts "retailer --- "+ retailer 
	puts "total cards --- "+@data.size.to_s
	puts "average offer --- "+ (1 - (@data.inject(:+).to_f / @data.size.to_f)).to_s

end
