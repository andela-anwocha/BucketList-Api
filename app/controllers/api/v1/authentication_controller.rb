module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = Authentication.encode(user_id: user.id)
          user.update(token: token)
          render json: { message: Message.login_success, token: token },
                 status: 200
        else
          render json: { error: Message.login_failed }, status: 401
        end
      end

      def logout
        if user_active?
          @user.update(token: nil)
          render json: { message: Message.logout_success }, status: 200
        end
      end
      
    end
  end
end
