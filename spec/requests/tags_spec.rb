require 'rails_helper'

RSpec.describe "Tags API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { sign_in(user) }
  let!(:tag1) { create(:tag, user: user, name: "仕事", color: "#FF0000") }
  let!(:tag2) { create(:tag, user: user, name: "勉強", color: "#00FF00") }

  describe "GET /api/v1/tags" do
    it "ユーザーのタグ一覧を取得できる" do
      get "/api/v1/tags", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response[0]["name"]).to eq("仕事")
      expect(json_response[1]["name"]).to eq("勉強")
    end
  end

  describe "POST /api/v1/tags" do
    context "有効なパラメータの場合" do
      let(:valid_params) do
        { tags: { name: "運動", color: "#0000FF" } }
      end

      it "タグを作成できる" do
        expect {
          post "/api/v1/tags", params: valid_params, headers: auth_headers
        }.to change(Tag, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("運動")
        expect(json_response["color"]).to eq("#0000FF")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) do
        { tags: { name: "", color: "" } }
      end

      it "エラーを返す" do
        post "/api/v1/tags", params: invalid_params, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Name can't be blank")
      end
    end
  end

  describe "DELETE /api/v1/tags/:id" do
    it "タグを削除できる" do
      expect {
        delete "/api/v1/tags/#{tag1.id}", headers: auth_headers
      }.to change(Tag, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "存在しないタグを削除するとエラー" do
      delete "/api/v1/tags/9999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
