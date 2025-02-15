FactoryBot.define do
    factory :tag do
      association :user
      name { "デフォルトタグ" }
      color { "#FFFFFF" }
    end
  end
  