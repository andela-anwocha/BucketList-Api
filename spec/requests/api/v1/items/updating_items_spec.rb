require "rails_helper"

RSpec.describe "Updating BucketList Item", type: :request do
  let(:user) { create(:user) }

  context "as an authenticated user" do
    before { login_user(user) }
    context "with valid bucketlist_id and valid item_id" do
      it "updates the bucketlist item" do
        route_params = { bucketlist_id: 1, id: 1 }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(json_response[:name]).to eq(params[:name])
        expect(response.status).to eq(200)
      end
    end

    context "with valid bucketlist_id and invalid item_id" do
      it "responds with not found status" do
        route_params = { bucketlist_id: 1, id: "invalid" }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "with invalid bucketlist_id and valid item_id" do
      it "responds with not found status" do
        route_params = { bucketlist_id: "invalid", id: 1 }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "with a non unique item name" do
      it "responds with a 422 http status error" do
        route_params = { bucketlist_id: 1, id: 1 }
        params = { name: user.bucket_lists.first.items.last.name, done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(422)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 http status error" do
      route_params = { bucketlist_id: 1, id: 1 }
      params = { name: "Name", done: false }
      put api_v1_bucketlist_item_url(route_params), params

      expect(response.status).to eq(401)
    end
  end
end
