class Api::V1::TasksController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :authenticate_api_v1_user!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    # ransackで検索・ソートを行う
    @q = current_api_v1_user.tasks.ransack(params[:q])  # params[:q] で受け取る
    @tasks = @q.result(distinct: true)  # 結果を取得
  
    # タグIDで絞り込み
    if params[:tag_id].present?
      @tasks = @tasks.joins(:tags).where(tags: { id: params[:tag_id] })
    end
  
    # 完了済みタスク・未完了タスクで絞り込み
    if params[:status].present?
      if params[:status] == 'completed'
        @tasks = @tasks.where.not(completion_date: nil)  # 完了済みタスク
      elsif params[:status] == 'incomplete'
        @tasks = @tasks.where(completion_date: nil)  # 未完了タスク
      end
    end
  
    render json: @tasks.to_json(include: :tags)
  end
  


  def show
    render json: @task, include: :tags
  end

  def create
    @task = current_api_v1_user.tasks.new(task_params)
  
    # タグの数が5個を超えていないか確認
    if params[:task][:tags].present? && params[:task][:tags].size > 5
      return render json: { errors: 'タグは最大5個までです' }, status: :unprocessable_entity
    end
  
    if params[:task][:tags].present?
      @task.tags = Tag.where(id: params[:task][:tags])
    end
  
    if @task.save
      render json: @task, include: :tags, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def update
    if params[:task][:tags]&.size.to_i > 5
      return render json: { errors: 'タグは最大5個までです' }, status: :unprocessable_entity
    end
  
    if @task.update(task_params)
      if params[:task][:tags]
        @task.tags = Tag.where(id: params[:task][:tags]) 
      end
  
      # reminder_timeが変更された場合、notifiedをfalseに設定
      if @task.saved_change_to_reminder_time?
        @task.assign_attributes(notified: false)
      end
  
      # completion_dateがnilの場合、completion_messageをnilに設定
      if @task.completion_date.nil?
        @task.assign_attributes(completion_message: nil)
      end
  
      @task.save
  
      render json: @task, include: :tags
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
    @task = current_api_v1_user.tasks.includes(:tags).find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority, :completion_date, :reminder_time, :completion_message)
  end
end