class DiarySerializer < ActiveModel::Serializer
  attributes :id,:user_id,:content,:is_public,:character_comment,:created_at

  belongs_to :user
end
