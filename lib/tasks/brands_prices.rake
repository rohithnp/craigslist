desc "Fetch retailer prices"
task :fetch_prices => :environment do 
	require 'nokogiri'  
	require 'open-uri' 
	require 'CGI'
	require 'paint'
	require 'timeout'

#	Brand.find(:all, :conditions => ["DATE(updated_at) = ? and discount = ?", 36.hours.ago.to_date, 0]).each do |brand|
#	Brand.find_all_by_discount(0).each do |brand|
#	Brand.find(:all, :conditions => ["DATE(updated_at) < ? and value > ?", 24.hours.ago.to_date, 0]).each do |brand|
	Brand.find(:all).each  do |brand|
		escaped_brand_name = CGI.escape(brand.name)
		total = 0
		@data = []
		search_url = "/search/sss?query=#{escaped_brand_name}+gift+card&srchType=T&minAsk=&maxAsk="  
		City.find(:all, :conditions => ["active = ?", true]).each do |city|
			url = city['url']+search_url
			begin
				doc = Nokogiri::HTML(open(url))
			rescue OpenURI::HTTPError, Timeout::Error
				puts Paint[url,:red]
				city.update_attribute(:active, false)
				next
			rescue 
				puts Paint[url,:red]
				city.update_attribute(:active, false)
				next				
			end

			if doc.css(".row").size == 0 then
				puts Paint[url,:yellow]

					#puts city["href"].to_s+" ---- "+"NO"
			else
				doc.css(".row").each do |row|
					value = row.css("a")[0].text[/\$[0-9\.]+/]
					price = row.css(".itempp").text[/[0-9][0-9\.]+/]
					if !value.nil? and !price.nil? and value[1..-1].to_f >= price.to_f then
						title = row.css("a")[0].text
						link = row.css("a")[0]["href"]
						puts Paint[url,:green]
						Post.create(:brand_id => brand.id, :title => title, :url => link, :price => price.to_f, :value => value[1..-1].to_f)
						total = total + value[1..-1].to_f
						@data << (value[1..-1].to_f - price.to_f) / value[1..-1].to_f
					else
						puts Paint[url,:yellow]	
					end
				end
			end
			city.update_attribute(:active, true)
		end
		if (@data.size > 0) then
			brand.update_attributes(:discount => (1 - (@data.inject(:+).to_f / @data.size.to_f)), :value => total)
		else 
			brand.touch
		end
	end
end