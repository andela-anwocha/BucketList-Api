module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate_request
      before_action :assign_bucket_list, only: [:create, :index]
      before_action :assign_item, only: :show

      def index
        render json: @bucket_list.items, status: :ok
      end

      def show
        render json: @item, status: :ok
      end

      def create
        @item = Item.new(item_params)
        if @item.save && @item.update(bucket_list: @bucket_list)
          render json: @item, status: :created,
                 location: api_v1_bucketlist_items_url(@bucket_list, @item)
        else
          render json: { errors: @item.errors }, status: :unprocessable_entity
        end
      end

      private

      def item_params
        params.permit(:name, :done)
      end

      def assign_bucket_list
        @bucket_list = @user.bucket_lists.find_by(id: params[:bucketlist_id])
        unless @bucket_list
          render json: { error: "Bucket List not found" }, status: :not_found
        end
      end

      def assign_item
        @item = @bucket_list.items.find_by(id: params[:id]) if @bucket_list
        unless @item
          render json: { error: "Bucket List not found" }, status: :not_found
        end
      end
    end
  end
end
