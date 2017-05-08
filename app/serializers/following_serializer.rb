class FollowingSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :user,
             :active_user_is_following

  def active_user_is_following
    @instance_options[:active_user_is_following]
  end
end
