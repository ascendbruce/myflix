Fabricator(:invitation) do
  recipient_name  { Faker.name }
  recipient_email { Faker::Internet.email }
  message         { Faker::Lorem.sentence }
end
