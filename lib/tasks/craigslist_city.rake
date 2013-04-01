desc "Fetch retailer prices"
task :fetch_cities => :environment do 
	require 'nokogiri'  
	require 'open-uri' 
	url ="http://www.craigslist.org/about/sites"
	doc = Nokogiri::HTML(open(url))  
	us = doc.css(".colmask")[0]
	city_links = us.css("a")
	city_links[1..-1].each do |link|
		City.create(:name => link.text, :url =>link['href'])
	end
end