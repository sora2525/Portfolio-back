require 'open-uri'  # リモートファイルを開くために必要

module Api
  module V1
    module Auth
      class GoogleLoginController < ApplicationController
        def create
          user = User.find_or_initialize_by(uid: params[:uid], provider: params[:provider])

          begin
            avatar_file = URI.open(params[:image])
          rescue OpenURI::HTTPError => e
            avatar_file = nil
            Rails.logger.error "画像のダウンロードに失敗しました: #{e.message}"
          end

          user.assign_attributes(
            uid: params[:uid],
            name: params[:name],
            provider: params[:provider],
            password: Devise.friendly_token[0, 20]
          )

          # アバターが未添付の場合に画像を添付
          if avatar_file && !user.avatar.attached?
            user.avatar.attach(
              io: avatar_file,
              filename: "avatar.jpg", 
              content_type: avatar_file.content_type
            )
          end

          if user.save
            create_and_return_token(user)
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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
