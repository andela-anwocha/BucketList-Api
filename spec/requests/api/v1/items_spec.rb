require "rails_helper"

RSpec.describe "BucketList Items", type: :request do
  let(:user) { create(:user) }
  before(:each) { login_user(user) }

  describe "GET /bucketlists/:id/items/" do
    context "as an authenticated user with valid bucketlist id" do
      it "returns all bucket list items" do
        bucket = user.bucket_lists.first
        get api_v1_bucketlist_items_url(bucketlist_id: 1), {}, header(user)

        expect(json_response.count).to eq(bucket.items.count)
      end
    end

    context "as an authenticated user with invalid bucketlist id" do
      it "returns a 404 status" do
        invalid_id = { bucketlist_id: "invalid" }
        get api_v1_bucketlist_items_url(invalid_id), {}, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "returns a 401 status" do
        bucket = user.bucket_lists.first
        get api_v1_bucketlist_items_url(bucketlist_id: 1), {}

        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /bucketlists/:bucketlist_id/items/:id" do
    context "as an authenticated user with valid bucketlist id and item id" do
      it "returns all bucket list items" do
        params = { bucketlist_id: 1, id: 1 }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(json_response[:name]).to eq(bucket.items.first.name)
      end
    end

    context "as an authenticated user with invalid bucketlist id" do
      it "returns a 404 status" do
        params = { bucketlist_id: "invalid", id: 1 }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an authenticated user with invalid item id" do
      it "returns a 404 status" do
        params = { bucketlist_id: 1, id: 200 }
        get api_v1_bucketlist_item_url(params), {}, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "returns a 401 status" do
        params = { bucketlist_id: 1, id: 1 }
        get api_v1_bucketlist_item_url(params), {}

        expect(response.status).to eq(401)
      end
    end
  end

  describe "POST /bucketlists/:id/items/" do
    context "as an authenticated user with valid bucketlist id" do
      it "creates the bucketlist item" do
        params = { name: "Name", done: false }
        bucket = user.bucket_lists.first
        post api_v1_bucketlist_items_url(bucket), params, header(user)

        expect(bucket.items.count).to eq(3)
        expect(response.status).to eq(201)
      end
    end

    context "as an authenticated user with invalid bucketlist id" do
      it "returns a 404 error" do
        params = { name: "Name", done: false }
        invalid_id = { bucketlist_id: "invalid" }
        post api_v1_bucketlist_items_url(invalid_id), params, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "does not create the bucketlist and returns a 401 status" do
        params = { name: "Name", done: false }
        post api_v1_bucketlist_items_url(bucketlist_id: 1), params

        expect(response.status).to eq(401)
      end
    end
  end
end
