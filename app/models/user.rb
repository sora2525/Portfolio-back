class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :diaries,dependent: :destroy
  has_one :preference, dependent: :destroy
  after_create :create_default_preference
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  # バリデーション
  validates :password, presence: true, on: :create

  private 

  def create_default_preference
    create_preference(affnity_level: 0) 
  end

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end

  public
  def as_json(options = {})
    super(options).merge(avatar_url: avatar_url)
  end
end
