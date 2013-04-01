desc "Update captcha flag"
task :update_captcha_flag => :environment do 
	require 'nokogiri'  
	require 'open-uri' 
	require 'net/http'
	require 'net/https'
	require 'uri'
	require 'json'


	uri = URI.parse("https://www.plasticjungle.com/balance-check/getCaptchaForBrandProduct")
	https = Net::HTTP.new(uri.host,uri.port)
	https.use_ssl = true
	req = Net::HTTP::Post.new(uri.path)

	Brand.where("retailer_id IS NOT NULL and captcha IS NULL").each do |brand|
		req.set_form_data({'brandProductId' => brand.retailer_id})

		start_time = Time.now
		begin
			res = https.request(req)
		rescue Timeout::Error
			brand.update_attribute(:captcha, false)
			puts brand.retailer_id+" : Timeout"
			next
		end
		json = JSON.parse(res.body)
		end_time = Time.now - start_time
		if json.has_key?('captchaUrl') then
			brand.update_attribute(:captcha, true)
		else
			brand.update_attribute(:captcha, false)
		end
		puts brand.retailer_id+" : "+brand.captcha.to_s+" : "+end_time.to_s
	end
end
	 
