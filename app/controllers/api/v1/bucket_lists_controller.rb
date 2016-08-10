module Api
  module V1
    class BucketListsController < ApplicationController
      before_action :authenticate_request
      before_filter :assign_bucket_list, only: [:show, :destroy, :update]

      def index
        @bucket_lists = @user.bucket_lists

        if @bucket_lists.empty?
          render json: { message: MessageService.bucketlist_empty }, status: :ok
        else
          render json: @bucket_lists.paginate_and_search(params), status: :ok
        end
      end

      def create
        @bucket_list = BucketList.new(bucket_list_params)
        if @bucket_list.save && @bucket_list.update(user: @user)
          render json: @bucket_list, status: :created,
                 location: api_v1_bucketlists_url(@bucket_list)
        else
          render json: { errors: @bucket_list.errors },
                 status: :unprocessable_entity
        end
      end

      def update
        if @bucket_list.update(bucket_list_params)
          render json: @bucket_list, status: :ok
        else
          render json: @bucket_list.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: @bucket_list, status: :ok
      end

      def destroy
        head :no_content if @bucket_list.destroy
      end

      private

      def bucket_list_params
        params.permit(:name)
      end

      def assign_bucket_list
        @bucket_list = @user.bucket_lists.find_by(id: params[:id])
        unless @bucket_list
          render json: { error: "Bucket List Not found" }, status: :not_found
        end
      end
    end
  end
end
