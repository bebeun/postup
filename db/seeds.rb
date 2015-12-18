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
	if n >= 1
		(n-1).times do |m|
			ua = UserAction.new()
			ua.support = "up" if n%2 == 0 
			ua.support = "down" if n%2 == 1
			ua.creator = user
			ua.supportable = User.find(m+1)
			ua.save!
			
			ua2 = UserAction.new()
			ua2.support = "up" if n%2 == 0 
			ua2.support = "down" if n%2 == 1
			ua2.creator = user
			ua2.supportable = PotentialUser.find(m+1)
			ua2.save!
		end
	end
end




