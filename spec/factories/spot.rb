FactoryBot.define do
  factory :spot do
    association :trip
    spot_icon { "location-dot" }
    title { "スポットのテスト" }
    date { Time.zone.today }
    start_time { Time.zone.now }
    end_time { 1.hour.from_now }
    cost { 1000 }
    memo { "メモのテスト" }
  end
end
