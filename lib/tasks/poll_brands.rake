desc "polling brands"
task :poll_brands => :environment do 
	require "capybara/rails"
	require "capybara/dsl"
require 'capybara/poltergeist'
require 'paint'
	include Capybara::DSL 
	Capybara.run_server = false
	Capybara.app_host = "https://qa.plasticjungle.net:28443"
	#Capybara.default_wait_time = 5
	#page.driver.browser.timeout = 5

	Capybara.register_driver :poltergeist do |app|
	  Capybara::Poltergeist::Driver.new(app, {debug: true, js_errors: false})
	end
		Capybara.current_driver = :poltergeist

	Capybara.javascript_driver = :poltergeist


	      def check_cart()
	      	return page.has_link?('Checkout with credit card')
	      end

	      def addCard()
	      	visit('/buy-gift-cards')
	      	within('div.cardGrid') do
	      		click_on(all('a').sample.text)
	      	end
	      	click_link('Add to Cart')
	      	sleep 2
	      	click_link('Shopping Cart')
	      end

	      def signIn()
			visit('/mygiftcards')
	     	fill_in("USERNAME", :with => "mementoonline@gmail.com")
	     	fill_in("PASSWORD", :with => "testing")
      	 	click_on('Sign in')
	     	click_on('Sign in')
	      end

	      def checkOut()
	        click_on('Checkout with credit card')
	      	fill_in('securityCode_PAYMENT', :with => "221")
	      	click_link('Submit Order')
	      end

	      def phoneVerify()
	      	if page.has_link?('Send Code Now') then 
	      		find(:xpath,"//div[@class='formRow'][1]/label[2]/input").set(true)
	      		click_link('Send Code Now')
	      		puts "Enter pin : "
	      		pin = STDIN.gets
	      		print pin
	      		page.driver.render "tmp/phone0.png"

	      		sleep 4
				fill_in('verificationCode', :with => pin.strip)
				page.driver.render "tmp/phone.png"

	      		find('input#verificationCode').set(pin.strip)
	      		click_link('Continue')
	      		
	      	else
	      		puts "no phone verify"
	      	end
	      end

	      def orderPage()
	      	all('h2') {|a| puts a.text}
	      end





	      signIn
	      while (!check_cart) do
	      	puts "empty card"
	      	addCard
	      end
	      puts "good to go"
	      checkOut
	      sleep 1
	      phoneVerify
	      orderPage
	      
=begin
	      fill_in("USERNAME", :with => "mementoonline@gmail.com")
	      fill_in("PASSWORD", :with => "testing")
      	  click_on('Sign in')
	      click_on('Sign in')
	      visit('/buy-gift-cards')

	      #page.evaluate_script("ioLoginWrapper('/login');")
	      within('div.cardGrid') do
	      	links = all('a')
	      	link = links.sample
	      	click_on(link.text)
	      	#.each { |a| puts a.text+" : "+a[:href] }
	      end
	      #all('a').each { |a| puts a.text+" : "+a[:href]}

	      page.driver.render "tmp/screenshot1.png"
	      #click_on('Add to Cart')
	      click_link('Add to Cart')
	      #page.driver.execute_script("pjCartUtils.addItemToCart('/additem/aicart', 'theminiassocprod0form');")
	      #sleep 4
	      #page.execute_script("pjCartUtils.addItemToCart('/additem/aicart', 'theminiassocprod0form');")
	      puts page.has_link?('Shopping Cart')

	      #click_on('cart_bubble')
	      #click_on('cart_bubble')

	      click_on('Shopping Cart')
	 	  page.driver.render "tmp/screenshot2.png"

	      click_on('Checkout with credit card')
	      sleep 0.5
	      fill_in('securityCode_PAYMENT', :with => "221")
	      click_link('Submit Order')
	      #page.driver.execute_script("checkoutUtils.submitOrder('checkoutInfoForm','/prepOnePageProcessOrder');")
	      #click_on('Submit Order')
	      #sleep 5
	      puts page.has_xpath?("//div[@class='formRow'][1]/label[2]/input")

	      find(:xpath,"//div[@class='formRow'][1]/label[2]/input").set(true)
	      page.driver.execute_script("phoneVerify.sendPhoneVerificationCode('phoneVerifyForm','/sendphoneverificationcode');")
	      pin = STDIN.gets
	      puts pin
	      fill_in("verificationCode", :with => pin)
	      sleep 2
	      page.driver.execute_script("phoneVerify.verifyPhoneCode('phoneVerifyForm','/verifyphonecode');")
	      #click_on('Continue')
	      sleep 5

	      #puts page.body

	      page.driver.render "tmp/screenshot3.png"
	      #all('a').each { |a| puts a.text == 'Delete' ? "success" : "fail" }
	      #pp page.body
=end
	  
	end