require "jwt"

class Authentication
  def self.encode(payload)
    exp = Time.now.to_i + 4 * 3600
    exp_payload = { data: payload, exp: exp }
    JWT.encode(exp_payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(
      JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    )[:data]
  rescue
    { error: Message.invalid_token }
  end
end
