class Api::V1::ChatsController < ApplicationController
    before_action :authenticate_api_v1_user!

    def index
        @chats = current_api_v1_user.chats.order(created_at: :asc)

        render json: @chats
    end

    def create
        @chat = current_api_v1_user.new(chat_params)

        if @chat.save
            render json: @chat
        else
            render json: {error: @chat.error.full_messages},status: :unprocessable_entity
        end
    end

    private

    def chat_params
        params.require(:chat).permit(:messages_type,:message)
    end
end
