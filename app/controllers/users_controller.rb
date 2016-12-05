class UsersController < ApplicationController
  def create
    new_user = User.create(user_creation_params)
    if new_user.valid?
      session[:user_id] = new_user.id
      render json: new_user.to_json
    else
      render json: new_user.errors.to_json
    end
  end

  def destroy
    current_user.destroy!
    session[:user_id] = nil
    render json: current_user.to_json
  end

  def index
    render json: User.all.to_json
  end

  def update
    if current_user.update_attributes(user_update_params)
      render json: current_user.to_json
    else
      render json: current_user.errors.to_json
    end
  end

  def show
    render json: user.to_json
  end

  def active_user
    render json: current_user.to_json
  end

  private

  def user
    @_user ||= User.find(params[:id])
  end

  def user_creation_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email)
  end
end
