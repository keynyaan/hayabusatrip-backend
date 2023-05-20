FactoryBot.define do
  factory :trip do
    association :user
    association :prefecture
    title { "旅行のテスト" }
    start_date { Time.zone.today }
    end_date { Time.zone.today + 1.day }
    memo { "メモのテスト" }
    image_path { "/images/default-trip-image.png" }
    is_public { false }
    trip_token { SecureRandom.alphanumeric(16) }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
