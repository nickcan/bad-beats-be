class SessionsController < ApplicationController
  def create
    @user = User.from_omniauth(auth_hash)
    session[:user_id] = @user.id
    redirect_to @user
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
