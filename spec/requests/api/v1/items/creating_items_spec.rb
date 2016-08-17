require "rails_helper"

RSpec.describe "Creating BucketList Items", type: :request do
  let(:user) { create(:user) }

  context "as an authenticated user" do
    before(:each) { login_user(user) }

    context "with a valid bucketlist id" do
      context "and a unique bucketlist name" do
        it "creates the bucketlist item" do
          params = { name: "Name", done: false }
          bucket = user.bucket_lists.first
          endpoint = api_v1_bucketlist_items_url(bucket)

          expect { post endpoint, params, header(user) }.
            to change(Item, :count).by(1)
          expect(response.status).to eq(201)
        end
      end

      context "and a non unique bucketlist name" do
        it "does not create the bucketlist item" do
          bucket = user.bucket_lists.first
          params = bucket.items.first.attributes
          endpoint = api_v1_bucketlist_items_url(bucket)

          expect { post endpoint, params, header(user) }.
            to_not change(Item, :count)
          expect(response.status).to eq(422)
        end
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a http 404 status error" do
        params = { name: "Name", done: false }
        invalid_id = { bucketlist_id: "invalid" }
        post api_v1_bucketlist_items_url(invalid_id), params, header(user)

        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "does not create the bucketlist" do
      params = { name: "Name", done: false }
      post api_v1_bucketlist_items_url(bucketlist_id: 1), params

      expect(response.status).to eq(401)
    end
  end
end
