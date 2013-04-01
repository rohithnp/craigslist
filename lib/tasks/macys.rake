desc "macysbot"
task :macys => :environment do 
	require "capybara/rails"
	require "capybara/dsl"
	require 'capybara/poltergeist'
	require 'paint'
	require 'rubygems'
		include Capybara::DSL 
		Capybara.run_server = false
		Capybara.app_host = "http://www1.macys.com"
		#Capybara.default_wait_time = 5
		#page.driver.browser.timeout = 5

		Capybara.register_driver :poltergeist do |app|
			Capybara::Poltergeist::Driver.new(app, {debug: true, js_errors: false })
		end
		Capybara.current_driver = :poltergeist
		Capybara.javascript_driver = :poltergeist



	visit('/shop/product/macys-red-star-e-gift-card?ID=666269&CategoryID=30668')
	fill_in("email", :with => "mementoonline@gmail.com")
	fill_in("amount", :with => "1000")
	find("img#addToBagButton666269").click
	sleep 1
	visit('/checkoutswf/checkout-webflow')
	sleep 1.5
	page.driver.resize(1920, 1200)
	choose('giftCardEntered')
	puts Paint[find("img#captchaImg")['src'],:red]
	page.driver.render "tmp/macys2.png"
	page.driver.browser.save_screenshot('tmp/file.png')
	captcha = STDIN.gets
	fill_in('giftcard2', :with => captcha.strip)
	fill_in('giftcard', :with => '657100165963812242')

	within("div.billing_style5") do
		find('img#applyButton').click
	end
	#all('img', :alt => 'Submit') {|a| puts Paint[a['id'],:yellow]}
	#find('img', :alt => 'Submit').click
	page.driver.render "tmp/macys.png"

	puts Paint[find('div#showGiftCardDetails').text,:green]

end