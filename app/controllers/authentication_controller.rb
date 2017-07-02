class AuthenticationController < ApplicationController
  def authenticate_user
    user = User.find_by_email(params[:email])
    if user
      if user.password_digest == "facebook-authorized account"
        render json: {errors: {invalid: "This email was registered using Facebook. Please use that option."}}.to_json, status: :unauthorized
      elsif user.authenticate(params[:password])
        render json: user.format_with_jwt_payload
      else
        render json: {errors: {invalid: 'Invalid email or password'}}.to_json, status: :unauthorized
      end
    else
      render json: {errors: {invalid: 'Invalid email or password'}}.to_json, status: :unauthorized
    end
  end

  def login_facebook
    user = User.from_omniauth(auth_hash)
    base_url = Rails.env === 'development' ? 'http://localhost:5001' : 'https://fantasybadbeats.com'
    redirect_to "#{base_url}/?auth_token=#{JsonWebToken.encode({user_id: user.id})}"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
