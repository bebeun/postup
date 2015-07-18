10.times do |n|
	description  = "description_user#{n+1}"
	description2  = "description2_user#{n+1}"
	email = "#{n+1}@az.fr"
	password = "password"
	name = "name#{n+1}"
	user = User.create!(email: email,password: password,password_confirmation: password, name: name)
	user.profiles << Profile.create!(description: description)
	user.profiles << Profile.create!(description: description2)
	user.save!
	
	description  = "description_user_potential#{n+1}"
	potentialuser = PotentialUser.new()
	potentialuser.profile = Profile.create!(description: description)
	potentialuser.save!
end

