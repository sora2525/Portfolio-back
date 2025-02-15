require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      name: "Test User"
    }
  end

  describe "POST /api/v1/auth" do
    it "ユーザー登録ができる" do
      post "/api/v1/auth", params: valid_params

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["email"]).to eq(valid_params[:email])
    end

    it "パスワード確認が一致しない場合、登録できない" do
      invalid_params = valid_params.merge(password_confirmation: "wrongpassword")

      post "/api/v1/auth", params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]["password_confirmation"]).to include("doesn't match Password")
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    it "ログインが成功する" do
      user = create(:user, email: "test@example.com", password: "password123")

      post "/api/v1/auth/sign_in", params: { email: "test@example.com", password: "password123" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["email"]).to eq(user.email)
    end

    it "無効なパスワードでログインできない" do
      user = create(:user, email: "test@example.com", password: "password123")

      post "/api/v1/auth/sign_in", params: { email: "test@example.com", password: "wrongpassword" }

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Invalid login credentials. Please try again.")
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    it "ログアウトが成功する" do
      user = create(:user)
      auth_headers = sign_in(user) 

      delete "/api/v1/auth/sign_out", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["success"]).to be_truthy
    end
  end

  describe "GET /api/v1/auth/validate_token" do
    it "トークンが有効ならユーザー情報を取得できる" do
      user = create(:user)
      auth_headers = sign_in(user)

      get "/api/v1/auth/validate_token", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["email"]).to eq(user.email)
    end

    it "無効なトークンではアクセスできない" do
      get "/api/v1/auth/validate_token", headers: { "access-token" => "invalid", "client" => "invalid", "uid" => "invalid" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/auth/password" do
    it "パスワードリセットメールを送信できる" do
      user = create(:user, email: "test@example.com")

      post "/api/v1/auth/password", params: { email: "test@example.com", redirect_url: "http://localhost:3000/reset_password" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to include("An email has been sent to 'test@example.com' containing instructions for resetting your password.")
    end
  end
end
