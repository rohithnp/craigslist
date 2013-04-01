desc "Clean Brands"
task :clean_brands => :environment do 
	Brand.destroy_all(:discount => nil, :value => nil)
end