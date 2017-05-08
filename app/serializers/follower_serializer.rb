class FollowerSerializer < ActiveModel::Serializer
  attributes :user,
             :active_user_is_following

  def active_user_is_following
    @instance_options[:active_user_is_following]
  end

  def user
    UserSerializer.new(object.follower).attributes
  end
end

