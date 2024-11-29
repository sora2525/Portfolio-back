class Api::V1::ChatsController < ApplicationController
    before_action :authenticate_api_v1_user!
  
    # チャット履歴を取得
    def index
      @chats = current_api_v1_user.chats.order(created_at: :asc)
      render json: @chats
    end
  
    # チャットを作成
    def create
      @chat = current_api_v1_user.chats.new(chat_params)
  
      if @chat.save
        render json: @chat
      else
        render json: { error: @chat.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy_all
      @chats = current_api_v1_user.chats
      @chats.destroy_all
      head :no_content 
    end
    
    
  
    private
  
    # Strong Parameters
    def chat_params
      params.require(:chat).permit(:message_type, :message)
    end
  end
  