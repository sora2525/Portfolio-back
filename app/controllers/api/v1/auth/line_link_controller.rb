module Api
  module V1
    module Auth
      class LineLinkController < ApplicationController
        before_action :authenticate_api_v1_user!

        def link
          user = current_api_v1_user
          if user.update(line_sub: params[:line_sub])
            render json: { user: user }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
