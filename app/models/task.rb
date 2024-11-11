class Task < ApplicationRecord
    belongs_to :user
    has_many :task_tags, dependent: :destroy
    has_many :tags, through: :task_tags

    enum priority: { none: 0, low: 1, medium: 2, high: 3 }, _prefix: true
  
    validates :title, presence: true, length: { maximum: 100 }
    validates :description, length: { maximum: 300 }, allow_blank: true
    validate :completion_date_cannot_be_after_due_date  
  
    private
  
    # 完了日が期日を超えていないか確認
    def completion_date_cannot_be_after_due_date
      if completion_date.present? && due_date.present? && completion_date > due_date
        errors.add(:completion_date, "期日を超えることはできません") 
      end
    end

  end
  