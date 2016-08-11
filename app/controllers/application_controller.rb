class ApplicationController < ActionController::API
  def authenticate_request
    user_id_in_token? && user_active?
  end

  private

  def auth_token
    Authentication.decode(http_token)
  end

  def user_active?
    @user = User.find_by(id: auth_token[:user_id])

    if @user && validate_token(@user.token)
      true
    else
      render json: { error: Message.unauthenticated }, status: :unauthorized
      false
    end
  end

  def validate_token(token)
    token == http_token
  end

  def http_token
    request.headers[:HTTP_AUTHORIZATION]
  end

  def user_id_in_token?
    if http_token && !auth_token[:error] && auth_token[:user_id]
      true
    else
      render json: { error: Message.invalid_token }, status: :unauthorized
      false
    end
  end
end
