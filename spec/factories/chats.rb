FactoryBot.define do
  factory :chat do
    association :user
    message { "テストメッセージ" }
    message_type { "user" } # ✅ 修正
  end
end
