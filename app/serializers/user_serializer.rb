class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :image_url,
             :name,
             :short_bio,
             :follower_count,
             :following_count,
             :post_count,
             :is_active_user_following

  def is_active_user_following
    if @instance_options[:is_active_user_following].present?
      true
    elsif @instance_options[:current_user].present?
      @instance_options[:current_user].is_following?(object.id)
    else
      false
    end
  end
end
