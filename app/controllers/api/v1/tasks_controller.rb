class Api::V1::TasksController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :authenticate_api_v1_user!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
  sort_by = params[:sort_by] || 'created_at'
  order = params[:order] || 'asc'
  tag_id = params[:tag_id]

  allowed_sort_columns = %w[created_at due_date priority completion_date]
  sort_by = allowed_sort_columns.include?(sort_by) ? "tasks.#{sort_by}" : 'tasks.created_at' # テーブル名を指定
  order = %w[asc desc].include?(order) ? order : 'asc'

  tasks_query = current_api_v1_user.tasks.includes(:tags).order("#{sort_by} #{order}")

  if tag_id.present?
    tasks_query = tasks_query.joins(:tags).where(tags: { id: tag_id })
  end

  @tasks = tasks_query
  render json: @tasks.to_json(include: :tags)
end




  def show
    render json: @task, include: :tags
  end

  def create
    @task = current_api_v1_user.tasks.new(task_params)
    if @task.save
      # `tags` パラメータが存在する場合は関連付けを行う
      if params[:task][:tags]
        @task.tags << Tag.where(id: params[:task][:tags])
      end
      render json: @task, include: :tags, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      if params[:task][:tags]
        @task.tags = Tag.where(id: params[:task][:tags]) 
      end
      render json: @task, include: :tags
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_contentj
  end

  private

  def set_task
    @task = current_api_v1_user.tasks.includes(:tags).find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority, :completion_date, :reminder_time)
  end
end
