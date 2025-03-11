class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :user_id
end
