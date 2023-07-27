FactoryBot.define do
  factory :user do
    uid { SecureRandom.uuid }
    created_at { Time.current }
    updated_at { Time.current }
    name { "新規ユーザー" }
    icon_path { "/images/default-user-icon.png" }
    last_login_time { nil }
  end
end
