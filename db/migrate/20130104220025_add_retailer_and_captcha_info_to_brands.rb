class AddRetailerAndCaptchaInfoToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :retailer_id, :string
    add_column :brands, :captcha, :boolean
  end
end
