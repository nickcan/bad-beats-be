class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :user_id, presence: true

  class << self
    def get_latest_posts(size: 15, page: nil)
      order(:created_at).reverse_order.limit(size).offset(page)
    end

    def get_latest_posts_by_sport(size: 15, page: nil, sport: nil)
      where(sport: sport).order(:created_at).reverse_order.limit(size).offset(page)
    end
  end
end
