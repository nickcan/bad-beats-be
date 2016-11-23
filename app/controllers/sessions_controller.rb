class SessionsController < ApplicationController
  def create
    user = User.find(param[:id])
    if user
      session[:user_id] = user.id
      render json: user.to_json
    end
  end

  def login_facebook
    user = User.from_omniauth(auth_hash)
    session[:user_id] = user.id
    redirect_to user
  end

  def destroy
    session[:user_id] = nil
    render nothing: true, status: 204
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
