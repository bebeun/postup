99.times do |n|
  name  = "Name : #{n+1}"
  email = "#{n+1}@az.fr"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password)
end