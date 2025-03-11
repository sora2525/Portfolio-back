class ModelTaskSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :due_date, :priority, :completion_date,
             :reminder_time, :created_at, :updated_at, :completion_message, :notified
  
  has_many :tags
end
