class UserSerializer < ActiveModel::Serializer
  attributes :authorization

  def authorization
    object.token
  end
end
