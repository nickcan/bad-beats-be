class ApplicationController < ActionController::API
  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def auth_token
    @_auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def current_user
    if user_id_in_token?
      @_current_user = User.find(auth_token[:user_id])
    end

    rescue ActiveRecord::RecordNotFound
      nil
  end

  def current_user_id
    user_id_in_token? ? auth_token[:user_id] : nil
  end

  private

  def http_token
    @_http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

end
