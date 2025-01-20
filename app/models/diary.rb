class Diary < ApplicationRecord
    belongs_to :user
    has_many_attached :images

   def as_json(options = {})
    super(options).merge(
      images: images.map { |img| 
      Rails.application.routes.url_helpers.url_for(img)
      }
    )
   end
end
