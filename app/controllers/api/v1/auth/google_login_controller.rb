module Api
  module V1
    module Auth
      class GoogleLoginController < ApplicationController
        def create
          user = User.find_or_initialize_by(email: params[:email])

          user.assign_attributes(
            uid: params[:uid],
            name: params[:name],
            image: params[:image],
            provider: params[:provider],
            password: Devise.friendly_token[0, 20] # ランダムパスワード生成
          )

          # トークンを生成
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
