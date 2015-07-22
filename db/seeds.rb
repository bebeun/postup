@fb = Category.create(origin: "FB")
@tw = Category.create(origin: "TW")

10.times do |n|
	description  = "benoit#{n+1}"
	description2  = "beun#{n+1}"
	email = "#{n+1}@az.fr"
	password = "password"
	name = "name#{n+1}"
	user = User.create!(email: email,password: password,password_confirmation: password, name: name)
	profile1 = Profile.create!(description: description, category: @fb)
	profile2 = Profile.create!(description: description2, category: @tw)
	user.profiles << profile1
	user.profiles << profile2
	user.save!
	

end

5.times do |n|
	
	description  = "unknownFB#{n+1}"
	potentialuser = PotentialUser.new()
	potentialuser.profile = Profile.create!(description: description, category: @fb)
	potentialuser.save!

end

5.times do |n|
	
	description  = "unknownTW#{n+1}"
	potentialuser = PotentialUser.new()
	potentialuser.profile = Profile.create!(description: description, category: @tw)
	potentialuser.save!

end

	conversation = Conversation.new()
	post = Post.new(conversation: conversation, creator_id: "3", title: "Test conversation title", content: "Test content")
	conversation.posts << post
	conversation.save!

	#callout = Callout.new(conversation: conversation, calloutable_id: "5", calloutable_type:"User")
	#callout.users << User.find("8")
	#callout.save!