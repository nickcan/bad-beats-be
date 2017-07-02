class UsersController < ApplicationController
  before_filter :authenticate_request!, except: [:create, :index]

  def create
    new_user = User.create(user_creation_params)
    if new_user.valid?
      render json: new_user.format_with_jwt_payload
    else
      render json: {errors: new_user.errors}.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy!
    render json: current_user
  end

  def index
    formatted_users = User.limit(100).map do |user|
      UserSerializer.new(user, is_active_user_following: current_user && current_user.is_following?(user.id)).attributes
    end

    render json: formatted_users
  end

  def update
    if current_user.update_attributes(user_update_params)
      render json: current_user
    else
      render json: current_user.errors
    end
  end

  def show
    render json: found_user, current_user: current_user
  end

  def active_user
    render json: current_user
  end

  def followers
    user_followers = found_user.search_followers(page: params[:page], size: params[:size])

    formatted_followers = user_followers.map do |follow_association|
      is_active_user_following = current_user.is_following?(follow_association.follower_id)
      follow_association.format_follower(is_active_user_following)
    end

    render json: formatted_followers.to_json
  end

  def following
    user_following = found_user.search_following(page: params[:page], size: params[:size])

    formatted_following = user_following.map do |follow_association|
      is_active_user_following = current_user.is_following?(follow_association.user_id)
      follow_association.format_following(is_active_user_following)
    end

    render json: formatted_following.to_json
  end

  private

  def found_user
    @_user ||= User.find(params[:id] || params[:user_id])
  end

  def user_creation_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email)
  end
end
