FactoryBot.define do
  factory :spot do
    association :trip
    category { "sightseeing" }
    name { "スポットのテスト" }
    date { Time.zone.today }
    start_time { '9:00' }
    end_time { '11:00' }
    cost { 1000 }
    memo { "メモのテスト" }
  end
end
