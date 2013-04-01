class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string :name
      t.decimal :discount, :precision => 2, :scale => 2
      t.decimal :value, :precision => 8, :scale => 2
      t.string :image_url
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
