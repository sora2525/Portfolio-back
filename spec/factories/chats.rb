FactoryBot.define do
  factory :chat do
    association :user
    message { "テストメッセージ" }
    message_type { "user" } 
  end
end
