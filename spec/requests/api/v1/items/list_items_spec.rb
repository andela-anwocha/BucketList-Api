require "rails_helper"

RSpec.describe "Listing BucketList Items", type: :request do
  let(:user) { create(:user) }

  context "as an authenticated user" do
    before { login_user(user) }
    context "with a valid bucketlist id" do
      it "returns all bucket list items" do
        bucket = user.bucket_lists.first
        get api_v1_bucketlist_items_url(bucketlist_id: 1), {}, header(user)

        expect(json_response.count).to eq(bucket.items.count)
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a 404 http status" do
        invalid_id = { bucketlist_id: "invalid" }
        get api_v1_bucketlist_items_url(invalid_id), {}, header(user)

        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 status" do
      get api_v1_bucketlist_items_url(bucketlist_id: 1), {}

      expect(response.status).to eq(401)
    end
  end
end
