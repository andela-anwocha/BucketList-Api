module Api
  module V1
    class AuthenticationController < ApplicationController

      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = Authentication.encode(user_id: user.id)
          user.update(token: token)
          render json: { notice: "Login successful", token: token }, status: 201
        else
          render json: { error: "Incorrect username or password" }, status: 401
        end
      end

      def logout
        if user_active?
          @user.update(token: nil)

          render json: { notice: "Logout successful" }, status: 200
        end
      end

    end
  end
end
