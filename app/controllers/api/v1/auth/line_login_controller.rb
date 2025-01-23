module Api
    module V1
      module Auth
        class LineLoginController < ApplicationController
          def create
            user = User.find_by(line_sub: params[:line_sub])
  
            if user
              create_and_return_token(user)
            else
                user = User.new(
                  uid: params[:uid],
                  name: params[:name],
                  image: params[:image],
                  provider: params[:provider],
                  line_sub: params[:line_sub],
                  password: Devise.friendly_token[0, 20]
                )
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
            render json: { message: 'Login successful', user: user }, status: :ok
          end
        end
      end
    end
  end
  