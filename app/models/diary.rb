class Diary < ApplicationRecord
    belongs_to :user
    has_many_attached :images

    validates :content, presence: true,length: { maximum: 200 }
    validates :character_comment, length: { maximum: 300 }, allow_blank: true

   def as_json(options = {})
    super(options).merge(
      images: images.map { |img| 
      Rails.application.routes.url_helpers.url_for(img)
      }
    )
   end
end
