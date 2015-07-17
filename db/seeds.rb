10.times do |n|
	description  = "description_user#{n+1}"
	email = "#{n+1}@az.fr"
	password = "password"
	name = "name#{n+1}"
	user = User.create!(email: email,password: password,password_confirmation: password, name: name)
	user.profiles << Profile.create!(description: description)
	user.save!
	
	description  = "description_user_potential#{n+1}"
	potentialuser = PotentialUser.create!()
	potentialuser.profile = Profile.create!(description: description)
	potentialuser.save!
end

