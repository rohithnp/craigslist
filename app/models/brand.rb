class Brand < ActiveRecord::Base
  has_many :posts
  attr_accessible :name, :discount, :value, :image_url, :description
end
