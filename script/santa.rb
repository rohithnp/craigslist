require 'net/http'
require 'net/https'
require 'uri'
require 'json'

#uri = URI.parse("https://www.plasticjungle.com/balance-check/getCaptchaForBrandProduct")
uri = URI.parse("https://www.plasticjungle.com/checkBalanceForSeller")
https = Net::HTTP.new(uri.host,uri.port)
https.use_ssl = true
req = Net::HTTP::Post.new(uri.path)



#req.set_form_data({'brandProductId' => 'PJ_Best_Buy'})
=begin
req.set_form_data(
				{
					'isBalanceCheck' => 'true', 
					'verifyTypeEnumId' => 'PJVT_BOT', 
					'redirectUrl' => '%2FFindCardBalanceExchangeValue',
					'url' => '%2FcheckBalanceForSeller',
					'cardBalance' => '50', 'quantity' => '1',
					'productId_text' =>'American+Airlines',
					'productId' => 'PJ_American_Airl',
					'cardNumber' => '6006494106823226898',
					'pinNumber' => '7755'
				})
=end
req.set_form_data(
				{
					'productId' => 'PJ_American_Airl',
					'cardNumber' => '6006494106823226898',
					'pin' => '7755'
				})
start_time = Time.now
res = https.request(req)
json = JSON.parse(res.body)
end_time = Time.now - start_time
puts json.has_key?('cardBalance')
puts json
puts end_time
 
