module RequestHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def login_user(user)
    post api_v1_login_url, email: user.email, password: "password"
    user.reload
  end

  def login_invalid_user
    post api_v1_login_url, email: "invalid_email", password: "password"
  end

  def auth_header(user)
    { "Token" => user.token }
  end

  def invalid_auth_header(user)
    { "Token" => "#{user.token}invalid" }
  end
end
