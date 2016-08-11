module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user && user.save
          login_user(user)
          render json: user, status: :created
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :token)
      end

      def login_user(user)
        token = Authentication.encode(user_id: user.id)
        user.update(token: token)
      end
    end
  end
end
