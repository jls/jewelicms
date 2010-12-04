Factory.define :user do |f|
  f.sequence(:login){|n| "example#{n}"}
  f.name 'Example User'
  f.sequence :email do |n| 
    "user#{n}@example.com" 
  end
  f.password 'example'
  f.password_confirmation 'example'
end