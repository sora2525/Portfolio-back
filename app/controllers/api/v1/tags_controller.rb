class Api::V1::TagsController < ApplicationController
    before_action :authenticate_api_v1_user!


    def index
        @tags = current_api_v1_user.tags.includes(:tasks) 
        render json: @tags, each_serializer: TagSerializer
    end

    def create
        @tag = current_api_v1_user.tags.build(tags_params)
        
        if @tag.save
          render json: @tag,serializer: TagSerializer, status: :created
        else
          render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @tag = current_api_v1_user.tags.find(params[:id])
        if @tag.destroy
          head :no_content 
        else
          render json: { error: "タグの削除に失敗しました" }, status: :unprocessable_entity
        end
      end
    private

    def tags_params
        params.require(:tags).permit(:name,:color)
    end
    
end
