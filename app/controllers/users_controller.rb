class UsersController < ApplicationController
  before_filter :authenticate_request!, only: [:active_user, :destroy, :update]

  def create
    new_user = User.create(user_creation_params)
    if new_user.valid?
      render json: new_user.format_with_jwt_payload
    else
      render json: new_user.errors
    end
  end

  def destroy
    current_user.destroy!
    session[:user_id] = nil
    render json: current_user
  end

  def index
    formatted_users = User.limit(100)
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
    render json: found_user.serialize
  end

  def active_user
    render json: current_user
  end

  private

  def found_user
    @_user ||= User.find(params[:id])
  end

  def user_creation_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email)
  end
end
