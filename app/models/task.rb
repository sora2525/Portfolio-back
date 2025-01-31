class Task < ApplicationRecord
  belongs_to :user
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :completion_message, length: { maximum: 300 }, allow_blank: true

  def self.ransackable_attributes(auth_object = nil)
    ["completion_date", "completion_message", "created_at", "description", "due_date", "id", "priority", "reminder_time", "title", "updated_at", "user_id"]
  end

end
