module Api
  module V1
    class BucketListsController < ApplicationController
      before_filter :authenticate_request!

      def create
        @bucket_list = BucketList.new(bucket_list_params)
        if @bucket_list.save
          @bucket_list.update(user: @user)
          render json: @bucket_list, status: 201
        else
          render json: { errors: @bucket_list.errors }, status: 422
        end
      end

      private

      def bucket_list_params
        params.permit(:name)
      end
    end
  end
end
