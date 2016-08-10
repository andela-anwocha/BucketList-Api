module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate_request
      before_action :assign_bucket_list, only: :create

      def create
        @item = Item.new(item_params)
        if @item.save && @item.update(bucket_list: @bucket_list)
          render json: @item, status: 201,
                 location: api_v1_bucketlist_items_url(@bucket_list, @item)
        else
          render json: { errors: @item.errors }, status: 422
        end
      end

      private

      def item_params
        params.permit(:name, :done)
      end

      def assign_bucket_list
        @bucket_list = @user.bucket_lists.find_by(id: params[:bucketlist_id])
        unless @bucket_list
          render json: { error: "Bucket List not found" }, status: 404
        end
      end

    end
  end
end