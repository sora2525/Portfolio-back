require 'open-uri'  

module Api
  module V1
    module Auth
      class GoogleLoginController < ApplicationController
        def create
          # ユーザーを検索
          user = User.find_by(uid: params[:uid], provider: params[:provider])
        
          if user
            create_and_return_token(user)
          else
            # ユーザーが見つからない場合  新しいユーザーを作成
            begin
              avatar_file = URI.open(params[:image])
            rescue OpenURI::HTTPError => e
              avatar_file = nil
              Rails.logger.error "画像のダウンロードに失敗しました: #{e.message}"
            end
        
            user = User.new(
              uid: params[:uid],
              name: params[:name],
              provider: params[:provider],
              password: Devise.friendly_token[0, 20]
            )
        
            if avatar_file && avatar_file.respond_to?(:content_type)
              user.avatar.attach(
                io: avatar_file,
                filename: "avatar.jpg",
                content_type: avatar_file.content_type
              )
            else
              Rails.logger.warn "アバター画像を添付できませんでした。ファイルが無効か、既に添付されています。"
            end
        
            if user.save
              create_and_return_token(user)
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        private

        def create_and_return_token(user)
          sign_in(:user, user)
          token_info = user.create_new_auth_token

          response.headers.merge!(token_info)
          render json: { message: 'User saved successfully', user: user }, status: :ok
        end
      end
    end
  end
end
