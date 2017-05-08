class FollowingsController < ApplicationController
  before_filter :authenticate_request!

  def create
    user_to_follow = User.find(params[:user_id])
    following_association = @current_user.following.create(user_id: user_to_follow.id)

    if following_association.valid?
      render json: FollowingSerializer.new(following_association, active_user_is_following: true)
    else
      render json: following_association.errors, status: :unprocessable_enitity
    end
  end

  def destroy
    following_user = User.find(params[:user_id])
    following_association = @current_user.following.find_by(user_id: following_user.id)
    following_association.destroy

    render json: FollowingSerializer.new(following_association, active_user_is_following: false)
  end
end
