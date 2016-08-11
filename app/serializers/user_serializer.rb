class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :password, :authorization

  def authorization
    object.token
  end
end
