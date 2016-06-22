name_a = ["Alpha","Bravo", "Charlie", "Delta", "Echo","Foxtrot","Golf", "Hotel", "India", "Juliet"]

3.times do |n|
	description  = "unknownFB#{n+1}"
	potentialuser = PotentialUser.new()
	profile = Facebook.create(description: description, owner: potentialuser)
	potentialuser.save!
end

3.times do |n|
	description  = "unknownTW#{n+1}"
	potentialuser = PotentialUser.new()
	profile = Twitter.create(description: description, owner: potentialuser)
	potentialuser.save!
end

4.times do |n|
	description  = "unknownWebsite#{n+1}.com"
	potentialuser = PotentialUser.new()
	profile = Website.create(description: description, owner: potentialuser)
	potentialuser.save!
end

10.times do |n|
	description  = "benoit#{n+1}"
	description2  = "beun#{n+1}"
	description3  = "bebeubeun#{n+1}.com"
	email = "#{n+1}@az.fr"
	password = "password"
	name = name_a[n]
	
	user = User.create(email: email,password: password,password_confirmation: password, name: name)
	profile1  = Facebook.create(description: description, owner: user)
	profile2  = Twitter.create(description: description2, owner: user)
	profile3  = Website.create(description: description3, owner: user)

end




