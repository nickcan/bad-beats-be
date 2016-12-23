class AuthenticationController < ApplicationController
  def authenticate_user
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render json: user.format_with_jwt_payload
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end
end
