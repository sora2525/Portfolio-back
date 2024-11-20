# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one :preference, dependent: :destroy
  after_create :create_default_preference


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :password, presence: true, on: :create

  private 
  def create_default_preference
    create_preference(affnity_level: 0) 
  end
end
