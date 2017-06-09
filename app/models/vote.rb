class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_presence_of :votable_id, :votable_type, :user_id

  validates_uniqueness_of :votable_type, scope: [:user_id, :votable_id], message: "User has already voted"

  after_create :set_vote_count
  after_destroy :set_vote_count

  class << self
    def get_latest_votes(page: nil, size: nil)
      size ||= 100

      includes(:user)
      .offset(size.to_i * page.to_i)
      .limit(size.to_i)
    end
  end

  def set_vote_count
    votable.update_attributes(vote_count: votable.votes.count)
  end
end
