class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_presence_of :votable_id, :votable_type, :user_id

  validates_uniqueness_of :votable_type, scope: [:user_id, :votable_id], message: "User has already voted"

  after_create :increment_vote_count
  after_destroy :decrement_vote_count

  def increment_vote_count
    votable.update_attributes(vote_count: votable.vote_count + 1)
  end

  def decrement_vote_count
    votable.update_attributes(vote_count: votable.vote_count - 1)
  end
end
