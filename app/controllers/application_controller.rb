class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token? && user_active?
      render json: { error: "Unauthorized" }, status: 401
    end
  end

  def user_active?
    @user = User.find_by(id: auth_token[:user_id])

    if @user && @user.token && validate_token(@user.token)
      true
    else
      render json: { error: "Unauthenticated User" }, status: 401
      false
    end
  end

  def auth_token
    Authentication.decode(http_token)
  end

  private

  def validate_token(token)
    return true if token == http_token
    render json: { error: "Invalid Token" }, status: 401
    false
  end

  def http_token
    request.headers[:HTTP_AUTHORIZATION]
  end

  def user_id_in_token?
    http_token && !auth_token[:error] && auth_token[:user_id]
  end
end
