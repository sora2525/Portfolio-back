FactoryBot.define do
  factory :task do
    title { "テストタスク" }
    description { "テスト用の説明" }
    due_date { "2025-02-06" }
    priority { 1 }
    reminder_time { "12:00" }
    completion_date { nil }
    completion_message { nil }
    association :user
  end
end
