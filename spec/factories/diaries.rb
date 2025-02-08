FactoryBot.define do
    factory :diary do
      association :user
      title { "テスト日記" }
      content { "これはテストの日記の内容です。" }
      is_public { false }
      character_comment { "これはキャラクターのコメントです。" }
    end
  end
  