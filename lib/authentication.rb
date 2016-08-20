require "jwt"

class Authentication
  def self.encode(payload)
    expiration = Time.now.to_i + 4 * 3600
    expiration_payload = { data: payload, exp: expiration }
    JWT.encode(expiration_payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(
      JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    )[:data]
  rescue
    { error: Message.invalid_token }
  end
end
