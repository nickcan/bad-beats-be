class PostSerializer < ActiveModel::Serializer
  belongs_to :user

  attributes :id,
             :user_id,
             :text,
             :sport,
             :created_at,
             :updated_at,
             :current_user_has_voted,
             :vote_count,
             :comments,
             :images,
             :tags

  def current_user_id
    @_current_user_id ||= @instance_options[:current_user_id]
  end

  def current_user_has_voted
    if current_user_id
      object.votes.any? { |votes| current_user_id == votes.user_id }
    else
      false
    end
  end

  def comments
    object.comments.first(5).map { |comment| comment.serialize(current_user_id) }
  end
end
