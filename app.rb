require 'tumblr'

settings = YAML::load(File.read(File.dirname(__FILE__) + '/config.yml'))

user = Tumblr::User.new(settings['email'], settings['password'])

Tumblr.blog = '1week1project'

posts = Tumblr::Post.all(:tagged => 'week-25')

posts.group_by{|x| x['tag'].grep /week.*/}.each_pair do |week, posts|
	puts "working on #{week}"
	# Score 1:
	score = [posts.find{|x| x['tag'].include?('success')} ? 25 : 0]

	# Score 2: Under 250 words
	under_250 = posts.all? do |post|
		post["regular_body"].split(/\s+/).size < 250
	end
	score << (under_250 ? 25 : 0)
	
	# Score 3: Beginning and Ending Posts
	bookends = posts.find{|x| x['tag'].include?('start')} && posts.find{|x| x['tag'].include?('done')}
	score << (bookends ? 25 : 0)
	
	# Score 4: Own opinion
	puts "How would you rate this week?"
	opinion = gets
	score << opinion.to_i
	puts score.inspect
	puts "#{week}: #{score.inject{|sum, n| sum + n}} #{score.inspect}"
end