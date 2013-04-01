desc "Fetch retailer prices"
task :fetch_images => :environment do 
	require 'nokogiri'  
	require 'open-uri' 

	url ="https://www.plasticjungle.com/buy-gift-cards"
	doc = Nokogiri::HTML(open(url))  
	retailer_dropdown = doc.css("div.sidebar div.widget")[3].css("select#selectMerchant option")
	retailer_links = doc.css("div.cardGrid a")
	retailer_images = doc.css("div.cardGrid img")
=begin
	retailer_images.each do |image|
		brand_name = image['alt']
		Brand.find(:all, :conditions => ["name like ?", brand_name]).each do |brand|
			brand.update_attribute(:image_url, "https://www.plasticjungle.com"+image['src'])
		end
	end
=end
	retailer_dropdown.each_with_index do |retailer,i|
			if retailer['value'] != "" and i > 0 then
				#puts retailer['value']+" "+retailer.text
				retailerDOc = Nokogiri::HTML(open("https://www.plasticjungle.com"+retailer['value']))
				image = retailerDOc.css("div.image img")[0]
				brand = Brand.find_or_create_by_name(retailer.text)
				brand.update_attribute(:image_url, image['src'])
				puts retailer.text+" "+ image['src']
			end
	end 
end