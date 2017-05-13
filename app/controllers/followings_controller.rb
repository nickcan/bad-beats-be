class FollowingsController < ApplicationController
  before_filter :authenticate_request!

  def create
    user_to_follow = User.find(params[:user_id])
    following_association = current_user.following.create(user_id: user_to_follow.id)

    if following_association.valid?
      render json: UserSerializer.new(following_association.user, is_active_user_following: true).attributes
    else
      render json: following_association.errors, status: :unprocessable_enitity
    end
  end

  def destroy
    following_user = User.find(params[:user_id])
    following_association = current_user.following.find_by(user_id: following_user.id)
    following_association.destroy

    render json: UserSerializer.new(following_association.user, is_active_user_following: false).attributes
  end
end
