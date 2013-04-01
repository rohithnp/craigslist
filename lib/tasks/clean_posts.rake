desc "Clean all posts"
task :clean_posts => :environment do 
	Post.destroy_all()
end