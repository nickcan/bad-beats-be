class Followings < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower, class_name: 'User'

  validates_presence_of :follower_id, :user_id

  validates_uniqueness_of :blocked, scope: [:follower_id, :user_id], message: "Already following this user"

  after_create :increment_followings_count
  after_destroy :decrement_followings_count

  def increment_followings_count
    user.update_attributes(follower_count: user.follower_count + 1)
    follower.update_attributes(following_count: follower.following_count + 1)
  end

  def decrement_followings_count
    user.update_attributes(follower_count: user.follower_count - 1)
    follower.update_attributes(following_count: follower.following_count - 1)
  end

  def format_follower(is_active_user_following = false)
    UserSerializer.new(follower, is_active_user_following: is_active_user_following)
  end

  def format_following(is_active_user_following = false)
    UserSerializer.new(user, is_active_user_following: is_active_user_following)
  end
end
