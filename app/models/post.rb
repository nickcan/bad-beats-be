class Post < ActiveRecord::Base
  belongs_to :user
  has_many :images, as: :imageable

  validates :text, presence: true
end
