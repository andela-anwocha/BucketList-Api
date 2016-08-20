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

  def header(user)
    { "HTTP_AUTHORIZATION" => user.token }
  end

  def invalid_header(user)
    { "HTTP_AUTHORIZATION" => "#{user.token}invalid" }
  end
end
