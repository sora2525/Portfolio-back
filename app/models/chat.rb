class Chat < ApplicationRecord
    belongs_to :user
    enum message_type: { user: 'user', character: 'character' }
    validates :message, presence: true, length: { maximum: 100 }
end
