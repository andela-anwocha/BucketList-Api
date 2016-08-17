require "rails_helper"

RSpec.describe "Showing BucketList Item", type: :request do
  let(:user) { create(:user) }

  context "as an authenticated user" do
    before(:each) { login_user(user) }

    context "with a valid bucketlist_id and valid item id" do
      it "returns all items for the bucketlist" do
        bucket = user.bucket_lists.first
        params = { bucketlist_id: bucket.id, id: bucket.items.first.id }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(json_response[:name]).to eq(bucket.items.first.name)
      end
    end

    context "with an invalid bucketlist_id and valid item_id" do
      it "responds with a 404 http status code" do
        params = { bucketlist_id: "invalid", id: 1 }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "with a valid bucketlist_id and invalid item_id" do
      it "responds with a 404 http status" do
        params = { bucketlist_id: 1, id: "invalid" }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 http status" do
      params = { bucketlist_id: 1, id: 1 }
      get api_v1_bucketlist_item_url(params), {}

      expect(response.status).to eq(401)
    end
  end
end
