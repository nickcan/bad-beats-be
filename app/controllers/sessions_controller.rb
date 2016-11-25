class SessionsController < ApplicationController
  def create
    user = User.find_by_email params[:email]
    if user
      if user.authenticate params[:password]
        session[:user_id] = user.id
        render json: user.to_json
      else
        if user.provider
          render json: {error: "User signed in using #{user.provider.capitalize} and we do not hold a password for you. Please sign in using that service."}, status: 400
        else
          render json: {error: "Passwords do not match"}
        end
      end
    else
      render json: {error: "No record found for email #{params[:email]}"}, status: 404
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
