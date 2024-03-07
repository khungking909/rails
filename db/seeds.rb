User.create!(name: "Huynh duc truong",
             email: "123@gmail.com",
             password: "123",
             password_confirmation: "123",
             admin: true,
             activated: true,
             activated_at: Time.zone.now
            )
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
              )
end
