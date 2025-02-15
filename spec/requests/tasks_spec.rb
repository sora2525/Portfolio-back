require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { sign_in(user) }
  let!(:task) { create(:task, user: user) }

  describe "GET /api/v1/tasks" do
    it "ユーザーのタスク一覧を取得できる" do
      get "/api/v1/tasks", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.first["title"]).to eq(task.title)
    end
  end

  describe "GET /api/v1/tasks/:id" do
    it "指定したタスクを取得できる" do
      get "/api/v1/tasks/#{task.id}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq(task.title)
    end

    it "存在しないタスクを取得するとエラー" do
      get "/api/v1/tasks/9999", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/tasks" do
    let(:valid_params) do
      { task: { title: "新しいタスク", description: "詳細", due_date: "2025-02-10", priority: 2, reminder_time: "2025-02-10T12:00:00+09:00", tags: [] } }
    end

    it "タスクを作成できる" do
      expect {
        post "/api/v1/tasks", params: valid_params, headers: auth_headers
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("新しいタスク")
    end

    it "無効なパラメータの場合はエラー" do
      invalid_params = { task: { title: "" } }

      post "/api/v1/tasks", params: invalid_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/tasks/:id" do
    let(:update_params) do
      { task: { title: "更新されたタスク", description: "更新された詳細" } }
    end

    it "タスクを更新できる" do
      put "/api/v1/tasks/#{task.id}", params: update_params, headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("更新されたタスク")
    end

    it "無効なパラメータの場合はエラー" do
      invalid_params = { task: { title: "" } }

      put "/api/v1/tasks/#{task.id}", params: invalid_params, headers: auth_headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    it "タスクを削除できる" do
      expect {
        delete "/api/v1/tasks/#{task.id}", headers: auth_headers
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "PUT /api/v1/tasks/:id/complete" do
    it "タスクを完了にできる" do
      put "/api/v1/tasks/#{task.id}", params: { task: { completion_date: Date.today.to_s } }, headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["completion_date"]).not_to be_nil
    end

    it "タスクを未完了に戻せる" do
      task.update(completion_date: Date.today)
      put "/api/v1/tasks/#{task.id}", params: { task: { completion_date: nil } }, headers: auth_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["completion_date"]).to be_nil
    end
  end
end
