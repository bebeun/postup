10.times do |n|
	description  = "benoit#{n+1}"
	description2  = "beun#{n+1}"
	email = "#{n+1}@az.fr"
	password = "password"
	name = "name#{n+1}"
	
#puts "user = User.new(email: email,password: password,password_confirmation: password, name: name)"
	user = User.new(email: email,password: password,password_confirmation: password, name: name)
	profile1 = Profile.new()
	profile1.identable = Facebook.new(description: description, owner: user)
#puts "profile2 = Profile.new()"	
	profile2 = Profile.new()

#puts "profile2.identable = Twitter.new(description: description2)"
	profile2.identable = Twitter.new(description: description2, owner: user)
#puts "user.profiles << profile2"
	user.profiles << profile1
	user.profiles << profile2
#puts "user.save!"
	user.save!

	

end

5.times do |n|
	description  = "unknownFB#{n+1}"
	potentialuser = PotentialUser.new()
	potentialuser.profile = Profile.create!()
	potentialuser.profile.identable = Facebook.create!(description: description, owner: potentialuser)
	potentialuser.save!
end

5.times do |n|
	description  = "unknownTW#{n+1}"
	potentialuser = PotentialUser.new()
	potentialuser.profile = Profile.create!()
	potentialuser.profile.identable = Twitter.create!(description: description, owner: potentialuser)
	potentialuser.save!
end


