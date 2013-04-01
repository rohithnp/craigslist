desc "Fetch retailer prices from granny and send email"
task :fetch_granny_all => :environment do 
	require 'nokogiri'  
	require 'open-uri' 
	require 'csv'
	require 'paint'
	require 'mail'



	#Send emails of reports 
	def sendEmails()

		Mail.defaults do
		  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
		                           :port      => 587,
		                           :domain    => "plasticjungle.com",
		                           :user_name => "plasticjungle",
		                           :password  => "Pla5t1c",
		                           :authentication => 'plain',
		                           :enable_starttls_auto => true }
		end

		mail = Mail.deliver do
			#to 'rohith@plasticjungle.net'	
			to 'dan@plasticjungle.net'
			cc 'alex@plasticjungle.net'
			bcc 'rohith@plasticjungle.net'
			from 'Granny Daily Charts <plasticjungle@plasticjungle.com>'
			subject "Granny Charts " + Time.now.strftime('%D').to_s
			
			text_part do
				body "Gift Card Granny charts for " + Time.now.strftime('%D').to_s
			end
			
			add_file "granny_sell_chart_"+Time.now.strftime('%m-%d-%Y').to_s+".csv"
			add_file "granny_buy_chart_"+Time.now.strftime('%m-%d-%Y').to_s+".csv"
		end	
	end

	def writeDataToCSV(file_name,headers,chunk_size,data)
		CSV.open(file_name+Time.now.strftime('%m-%d-%Y').to_s+".csv", "wb") do |csv|
			csv << headers
			data.each_slice(chunk_size).each do |chunk|
				csv << chunk
			end
		end
	end

	def scrapeSell()
		url = "http://www.giftcardgranny.com/sell-a-gift-card/"
		doc = Nokogiri::HTML(open(url))  

		#get headers from table
		headers = doc.xpath("//table[@class='sell']/thead/tr").text.split("\n")	

		#parse data from each row in table and put into array
		table_data = doc.xpath("//table[@class='sell']/tbody/tr/td")
		data = []

		#data => [BRAND_NAME, CardPool ABC, giftcards.com, Zen, PJ, Rescue, Monkey]
		table_data.each do |td| 
			#skip any cells that dont have information 
			if td.text =~ /\w/ then
				data.push(td.text)
			else
			#push blanks to keep formatting for excel
				data.push(" ")
			end
		end

		#write data into csv file
		#break into chunks(size = 8) to get a new line in csv
		writeDataToCSV("granny_sell_chart_",headers,8,data)
	end

	def scrapeBuy()
		start_time = Time.now
		url = "http://www.giftcardgranny.com/buy-gift-cards/"
		doc = Nokogiri::HTML(open(url))  
		headers = ["Brand","Type","Card Value", "Price", "Discount", "Shipping", "Seller"]
		data = []
		dropdown_list = doc.xpath("//select[@class='text']/option")
		dropdown_list[1..dropdown_list.size-1].each do |retailer|
			#print retailer['value']


			retailer_url = "http://www.giftcardgranny.com"+retailer['value']
			sleep 0.1
			begin
				retailer_doc = Nokogiri::HTML(open(URI::encode(retailer_url)))  
			rescue 
				retry
			end

			brand = retailer_doc.xpath("//ul[@class='breadcrumb']/li[last()]")
			
			table_rows = retailer_doc.xpath("//table[@id='discount_card_list']/tbody/tr")

			#each row represents a specific card (or multiples of the same card)
			table_rows.each do |row|
				#use buffer array to hold each card data
				buffer = []
				#use count to hold quantity
				count = 0

				#we dont want data from shop or logo
				row.css("td").each do |td|
					next if  td['class'].eql? "shop"

					if td['class'].eql? "logo" 
						buffer.push(brand.text.strip)
					elsif td['class'].eql? "quantity" 
						count = td.css("div").text.delete("^0-9")
						count = 1 if count.nil? or count.empty?
					else
						buffer.push(td.text.strip)
					end
				end
			
				#write out buffer to data array(write multiple cards)
				count.to_i.times do
					data.push(*buffer)
				end
			end
			
			#puts "------------ NEW ROW -----------"
		end
		writeDataToCSV("granny_buy_chart_",headers,7,data)
		end_time = Time.now - start_time
		puts Paint[end_time,:green]


	end

	scrapeSell
	scrapeBuy
	sendEmails
end