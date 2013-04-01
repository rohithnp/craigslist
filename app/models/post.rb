class Post < ActiveRecord::Base
  belongs_to :brand
  attr_accessible :brand_id, :title, :price, :value, :url
end
