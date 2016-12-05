class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  has_many :images, as: :imageable, dependent: :destroy

  validates :post_id, presence: true
  validates :user_id, presence: true
end
