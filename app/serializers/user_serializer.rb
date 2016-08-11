class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :password, :token
end
