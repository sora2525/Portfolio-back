class Api::V1::DiariesController < ApplicationController
    before_action :authenticate_api_v1_user!
    before_action :set_diary, only: [:show, :update, :destroy]
  
    def index
      @diaries = current_api_v1_user.diaries.includes(user: { avatar_attachment: :blob }, images_attachments: :blob).order(created_at: :desc)
      render json: @diaries.to_json(
        include: {
          user: { 
            only: [:id, :name], 
            methods: [:avatar_url]
          }
        }
      )
    end
  
    def public_index
      @diaries = Diary.where(is_public: true).includes(user: { avatar_attachment: :blob }, images_attachments: :blob).order(created_at: :desc)
      render json: @diaries.to_json(
        include: {
          user: { 
            only: [:id, :name], 
            methods: [:avatar_url]
          }
        }
      )
    end
  
    def show
      if @diary
        render json: @diary
      else
        render json: { error: 'アクセス権がありません' }, status: :forbidden
      end
    end
  
    def create
      @diary = current_api_v1_user.diaries.new(diary_params)
      if @diary.save
        render json: @diary, status: :created
      else
        render json: { errors: @diary.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
        if @diary.update(diary_params)
          render json: @diary
        else
          render json: { errors: @diary.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
  
    def destroy
      @diary.destroy
      head :no_content
    end
  
    private
  
    def set_diary
      @diary = current_api_v1_user.diaries.find_by(id: params[:id])
      unless @diary
        render json: { error: 'アクセス権がありません' }, status: :forbidden
      end
    end
  
    def diary_params
      params.require(:diary).permit(:title, :content, :is_public, :character_comment, images: [])
    end
  end
  