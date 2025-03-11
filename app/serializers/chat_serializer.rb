class ChatSerializer < ActiveModel::Serializer
  attributes :id,:user_id,:message_type,:message,:created_at
  belongs_to :user
end
