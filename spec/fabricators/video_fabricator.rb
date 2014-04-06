Fabricator(:video) do
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }

  category
end
