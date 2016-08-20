module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate_request, :assign_bucket_list
      before_action :assign_item, only: [:show, :destroy, :update]

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

      def update
        if @item.update(item_params)
          render json: @item, status: :ok
        else
          render json: { errors: @item.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        head :no_content if @item.destroy
      end

      private

      def item_params
        params.permit(:name, :done)
      end

      def assign_bucket_list
        @bucket_list = @user.bucket_lists.find_by(id: params[:bucketlist_id])
        unless @bucket_list
          render json: { error: Message.no_bucket }, status: :not_found
        end
      end

      def assign_item
        @item = @bucket_list.items.find_by(id: params[:id]) if @bucket_list
        unless @item
          render json: { error: Message.no_item }, status: :not_found
        end
      end
    end
  end
end
