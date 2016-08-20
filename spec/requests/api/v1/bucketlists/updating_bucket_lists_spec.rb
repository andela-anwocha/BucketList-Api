require "rails_helper"

RSpec.describe "Updating BucketLists", type: :request do
  let(:user) { create(:user) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      context "using a unique bucketlist name" do
        it "updates the bucketlist" do
          params = { name: "Name" }
          bucket = user.bucket_lists.first
          put api_v1_bucketlist_url(id: bucket.id), params, header(user)
          user.reload

          expect(user.bucket_lists.first.name).to eq(params[:name])
          expect(response.status).to eq(200)
        end
      end

      context "with a non unique bucketlist name" do
        it "does not update the bucketlist" do
          params = { name: user.bucket_lists.last.name }
          valid_id = { id: user.bucket_lists.first.id }
          put api_v1_bucketlist_url(valid_id), params, header(user)
          user.reload

          expect(user.bucket_lists.first.name).to_not eq(params[:name])
          expect(response.status).to eq(422)
        end
      end
    end

    context "with an invalid bucket_list id" do
      it "does not update the bucket list" do
        params = { name: "Name" }
        invalid_id = { id: "invalid" }
        put api_v1_bucketlist_url(invalid_id), params, header(user)
        user.reload

        expect(user.bucket_lists.first.name).to_not eq(params[:name])
        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "does not update the bucketlist" do
      params = { name: user.bucket_lists.last.name }
      valid_id = { id: user.bucket_lists.first.id }
      put api_v1_bucketlist_url(valid_id), params
      user.reload

      expect(user.bucket_lists.first.name).to_not eq(params[:name])
      expect(response.status).to eq(401)
    end
  end
end
