class Task < ApplicationRecord
    belongs_to :user
    has_many :task_tags, dependent: :destroy
    has_many :tags, through: :task_tags

    enum priority: { none: 0, low: 1, medium: 2, high: 3 }, _prefix: true
  
    validates :title, presence: true, length: { maximum: 100 }
    validates :description, length: { maximum: 300 }, allow_blank: true
  
   

  end
  