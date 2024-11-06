class Api::V1::TasksController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    
    # authenticate_user! の代わりに DeviseTokenAuth 用のメソッドを使用
    before_action :authenticate_api_v1_user!
    before_action :set_task, only: [:show, :update, :destroy]
  
    def index
      @tasks = current_api_v1_user.tasks 
      render json: @tasks
    end
  
    def show
      render json: @task
    end
  
    def create
      @task = current_api_v1_user.tasks.new(task_params) 
      if @task.save
        render json: @task, status: :created
      else
        render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @task.update(task_params)
        render json: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @task.destroy
      head :no_content
    end
  
    private
  
    def set_task
      @task = current_api_v1_user.tasks.find(params[:id]) 
    end
  
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :completion_date, :reminder_time)
    end
  end
  