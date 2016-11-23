class UsersController < ApplicationController
  def create
    new_user = User.new(user_creation_params)
    if new_user.save
      render json: new_user.to_json
    else
      render json: new_user.errors.to_json
    end
  end

  def destroy
    user.destroy
    render nothing: true, status: :no_content
  end

  def index
    render json: User.all.to_json
  end

  def update
    if user.update_attributes(user_update_params)
      render json: user.to_json
    else
      render json: user.errors.to_json
    end
  end

  def show
    render json: user.to_json
  end

  private

  def user
    @_user ||= User.find(params[:id])
  end

  def user_creation_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
