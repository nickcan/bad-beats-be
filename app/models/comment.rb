class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy

  validates_presence_of :post_id, :user_id
  validates :message, length: { maximum: 500 }, presence: true

  class << self
    def get_latest_comments(size: 15, page: nil)
      order(:created_at).limit(size).offset(page)
    end
  end

  def serialize(current_user_id = nil)
    {
      id: id,
      post_id: post_id,
      created_at: created_at,
      updated_at: updated_at,
      message: message,
      current_user_has_voted: votes.find_by(user_id: current_user_id).present?,
      vote_count: votes.count,
      user: user.serialize
    }
  end
end
