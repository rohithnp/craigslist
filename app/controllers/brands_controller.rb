class BrandsController < ApplicationController
  def index
    @brands = Brand.find(:all, :conditions => "image_url is NOT NULL", :order => "value DESC")
    number_to_send_to = "4252838252"

    twilio_sid = "ACf08eef96de0705fe22b50e68d89dfd8b"
    twilio_token = "f20e09cc73536fad72b284c0fd506de5"
    twilio_phone_number = "2532371526"

    @twilio_client = Twilio::REST::Client.new(twilio_sid, twilio_token)
=begin
    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "This is an message. It gets sent to #{number_to_send_to}"
    )
=end
  end

  def getCaptcha
    @rid  = params

    uri = URI.parse("https://www.plasticjungle.com/balance-check/getCaptchaForBrandProduct")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({'brandProductId' => @rid['brandProductId']})
    start_time = Time.now
    begin
      res = https.request(req)
    rescue Timeout::Error
    end
    json = res.body
    respond_to do |format|
      format.js{
        render :json => json.to_json
      }
    end
  end

  def getBalance
    @rid  = params

    uri = URI.parse("https://www.plasticjungle.com/checkBalanceForSeller")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    if @rid.has_key?(:captchaId) then
      req.set_form_data(
          {
            'productId' => @rid['brandProductId'],
            'cardNumber' => @rid['cardNumber'],
            'pin' => @rid['pin'],
            'captchaId' => @rid['captchaId'],
            'captchaInput' => @rid['captchaInput']
          })
    else
      req.set_form_data(
          {
            'productId' => @rid['brandProductId'],
            'cardNumber' => @rid['cardNumber'],
            'pin' => @rid['pin']
          })
    end
    start_time = Time.now
    begin
      res = https.request(req)
    rescue Timeout::Error
    end
    json = res.body
    respond_to do |format|
      format.js{
        render :json => json.to_json
      }
    end
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      redirect_to @brand, :notice => "Successfully created brand."
    else
      render :action => 'new'
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      redirect_to @brand, :notice  => "Successfully updated brand."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    name = @brand['name']
    redirect_to brands_url, :notice => "Successfully destroyed #{name}."
  end
end
