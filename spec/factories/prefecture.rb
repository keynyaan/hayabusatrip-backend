FactoryBot.define do
  factory :prefecture do
    sequence(:name) { |n| "prefecture#{n}" }
    sequence(:image_path) { |n| "https://example.com/prefecture#{n}.jpg" }
  end
end
