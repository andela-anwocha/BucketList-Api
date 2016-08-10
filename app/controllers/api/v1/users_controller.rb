class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user && user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :token)
  end
end
