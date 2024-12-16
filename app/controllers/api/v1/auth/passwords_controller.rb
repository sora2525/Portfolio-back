# app/controllers/api/v1/auth/passwords_controller.rb
module Api
    module V1
      module Auth
        class PasswordsController < DeviseTokenAuth::PasswordsController
          # パスワードリセットの外部リダイレクトを許可する
          def edit
            @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
  
            if @resource && @resource.reset_password_period_valid?
              @resource.allow_password_change = true if recoverable_enabled?
              @resource.save!
  
              yield @resource if block_given?
  
              redirect_to DeviseTokenAuth::Url.generate(@redirect_url, reset_password_token: resource_params[:reset_password_token]), allow_other_host: true
            else
              render_edit_error
            end
          end
        end
      end
    end
  end
  