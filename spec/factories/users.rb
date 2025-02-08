FactoryBot.define do
    factory :user do
      name { "テストユーザー" }
      email { "test#{rand(1000)}@example.com" } # 既存のユーザーと重複しないようにランダムなメールを生成
      password { "password123" }
      password_confirmation { "password123" }
    end
  end
  