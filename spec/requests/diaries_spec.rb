require 'rails_helper'

RSpec.describe "Diaries API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { sign_in(user) }
  let(:other_user) { create(:user) }
  let(:other_auth_headers) { sign_in(other_user) }

  let!(:public_diary) { create(:diary, user: user, title: "公開日記", content: "公開された日記です", is_public: true) }
  let!(:private_diary) { create(:diary, user: user, title: "非公開日記", content: "これは非公開", is_public: false) }
  let!(:other_private_diary) { create(:diary, user: other_user, title: "他人の非公開日記", content: "アクセス不可", is_public: false) }

  describe "GET /api/v1/diaries" do
    it "ユーザーの日記一覧を取得できる" do
      get "/api/v1/diaries", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.count).to eq(2)
      expect(json.map { |d| d["title"] }).to include("公開日記", "非公開日記")
    end
  end

  describe "GET /api/v1/diaries/public_index" do
    it "認証ありで公開日記一覧を取得できる" do
      get "/api/v1/diaries/public_index", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.count).to eq(1)
      expect(json.first["title"]).to eq("公開日記")
    end

    it "認証なしでアクセスするとエラーになる" do
      get "/api/v1/diaries/public_index"

      expect(response).to have_http_status(:unauthorized)
    end
  end


    context "他のユーザーの非公開日記" do
      it "アクセスが拒否される (403 Forbidden)" do
        get "/api/v1/diaries/#{other_private_diary.id}", headers: auth_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /api/v1/diaries" do
    let(:valid_params) { { diary: { title: "新しい日記", content: "内容", is_public: true } } }
  
    it "無効なパラメータの場合はエラー" do
  invalid_params = { diary: { title: "", content: "" } }

  post "/api/v1/diaries", params: invalid_params, headers: auth_headers

  expect(response).to have_http_status(:unprocessable_entity)
  json = JSON.parse(response.body)
  expect(json["errors"]).to include("Content can't be blank") 
end

  
it "無効なパラメータの場合はエラー" do
    invalid_params = { diary: { title: "", content: "" } } 
  
    post "/api/v1/diaries", params: invalid_params, headers: auth_headers
  
    expect(response).to have_http_status(:unprocessable_entity)
    json = JSON.parse(response.body)
    expect(json["errors"]).to include("Content can't be blank") 
  end
  end
  
  describe "PUT /api/v1/diaries/:id" do
    let(:update_params) { { diary: { title: "更新された日記" } } }
  
    it "日記を更新できる" do
      put "/api/v1/diaries/#{private_diary.id}", params: update_params, headers: auth_headers
  
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("更新された日記")
    end
  
    it "無効なパラメータの場合はエラー" do
        invalid_params = { diary: { title: "", content: "" } }
      
        put "/api/v1/diaries/#{private_diary.id}", params: invalid_params, headers: auth_headers
      
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Content can't be blank") 
      end
  end

  describe "DELETE /api/v1/diaries/:id" do
    it "日記を削除できる" do
      expect {
        delete "/api/v1/diaries/#{private_diary.id}", headers: auth_headers
      }.to change(Diary, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
