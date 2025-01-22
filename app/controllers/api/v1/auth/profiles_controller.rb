class Api::V1::Auth::ProfilesController < ApplicationController
    before_action :authenticate_api_v1_user!
  
    def update
      if current_api_v1_user.update(user_params)
        render json: { message: "プロフィールが更新されました", user: current_api_v1_user }, status: :ok
      else
        render json: { errors: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :avatar)
    end
  end
  