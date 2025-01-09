module Api
    module V1
      module Auth
        class LineLinkController < ApplicationController
          before_action :authenticate_user!
  
          def link
            # 現在ログイン中のユーザー
            user = current_user
  
            # LINEの連携情報を追加
            if user.update(line_sub: params[:line_sub])
              render json: { message: "LINE連携が完了しました！", user: user }, status: :ok
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
  