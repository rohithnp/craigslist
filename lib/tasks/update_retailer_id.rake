desc "Update retailer ids"
task :update_retailer_ids => :environment do 
	require 'nokogiri'  
	require 'open-uri' 

	url ="https://www.plasticjungle.com/balance-check"
	doc = Nokogiri::HTML(open(url))  
	retailer_dropdown = doc.css("select.merchant option")
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
				#retailerDOc = Nokogiri::HTML(open("https://www.plasticjungle.com"+retailer['value']))
				#image = retailerDOc.css("div.image img")[0]
				brand = Brand.find_or_create_by_name(retailer.text)
				#brand.update_attribute(:image_url, image['src'])
				brand.update_attribute(:retailer_id, retailer['value'])
				puts brand.retailer_id
			end
	end 
end