class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :brand_id
      t.string :title
      t.decimal :price
      t.decimal :value
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
