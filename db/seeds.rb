User.create!(name: "Taro", 
             email: "Taro@exemple.com",
             password: "password", 
             password_confirmation: "password")

#追加のユーザーをまとめて生成
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end