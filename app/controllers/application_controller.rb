class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        include DeviseHackFakeSession
      
        before_action :configure_permitted_parameters, if: :devise_controller?
      
        private
      
        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        end
      
        def sign_in_params
          params.permit(:email, :password)
        end
      
        def sign_up_params
          params.permit(:name, :email, :password, :password_confirmation)
        end
      
        def account_update_params
          params.permit(:name, :email, :password, :password_confirmation, :current_password)
        end
        
      end
      