class CommentSerializer < ActiveModel::Serializer
  attributes :id,
             :post_id,
             :user_id,
             :created_at,
             :updated_at,
             :message,
             :current_user_has_voted,
             :vote_count,
             :user

  def current_user_id
    @_current_user_id ||= @instance_options[:current_user_id]
  end

  def current_user_has_voted
    if current_user_id
      object.votes.any? { |vote| current_user_id == vote.user_id }
    else
      false
    end
  end

  def user
    UserSerializer.new(object.user).attributes
  end
end
