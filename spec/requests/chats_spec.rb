require 'rails_helper'

RSpec.describe "Chats API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { sign_in(user) }
  let!(:chat1) { create(:chat, user: user, message: "Hello!", message_type: "user") }
  let!(:chat2) { create(:chat, user: user, message: "How are you?", message_type: "character") }

  describe "GET /api/v1/chats" do
    it "ユーザーのチャット履歴を取得できる" do
      get "/api/v1/chats", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response[0]["message"]).to eq("Hello!")
      expect(json_response[1]["message"]).to eq("How are you?")
    end
  end

  describe "POST /api/v1/chats" do
    context "有効なパラメータの場合" do
      let(:valid_params) do
        { chat: { message_type: "user", message: "This is a test chat." } }
      end

      it "チャットを作成できる" do
        post "/api/v1/chats", params: valid_params, headers: auth_headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("This is a test chat.")
        expect(json_response["message_type"]).to eq("user")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) do
        { chat: { message_type: "", message: "" } }
      end

      it "エラーを返す" do
        post "/api/v1/chats", params: invalid_params, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to include("Message can't be blank")
      end
    end
  end

  describe "DELETE /api/v1/chats/destroy" do
    it "ユーザーの全チャット履歴を削除できる" do
      delete "/api/v1/chats/destroy", headers: auth_headers

      if response.status == 404
        expect(JSON.parse(response.body)["error"]).to eq("No chat history found")
      else
        expect(response).to have_http_status(:no_content)
      end

      get "/api/v1/chats", headers: auth_headers
      json_response = JSON.parse(response.body)
      expect(json_response).to be_empty
    end
  end
end
