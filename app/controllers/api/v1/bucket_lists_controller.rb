module Api
  module V1
    class BucketListsController < ApplicationController
      before_action :authenticate_request
      before_action :assign_bucket_list, only: [:show, :destroy]

      def index
        render json: @user.bucket_lists, status: :ok
      end

      def create
        @bucket_list = BucketList.new(bucket_list_params)
        if @bucket_list.save
          @bucket_list.update(user: @user)
          render json: @bucket_list, status: :created
        else
          render json: { errors: @bucket_list.errors },
                 status: :unprocessable_entity
        end
      end

      def show
        if @bucket_list
          render json: @bucket_list, status: :ok
        else
          render json: { error: "Bucket List not found" }, status: :not_found
        end
      end

      def destroy
        if @bucket_list && @bucket_list.destroy
          head :no_content
        else
          render json: { errors: "Bucket List Not found" }, status: 404
        end
      end

      private

      def bucket_list_params
        params.permit(:name)
      end

      def assign_bucket_list
        @bucket_list = BucketList.find_by(id: params[:id])
      end
    end
  end
end
