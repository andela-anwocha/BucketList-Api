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
        get api_v1_bucketlist_items_url(bucketlist_id: 1), {}

        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /bucketlists/:bucketlist_id/items/:id" do
    context "as an authenticated user with valid bucketlist id and item id" do
      it "returns all bucket list items" do
        bucket = user.bucket_lists.first
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
      it "creates the bucketlist item when a unique name is given" do
        params = { name: "Name", done: false }
        bucket = user.bucket_lists.first
        endpoint = api_v1_bucketlist_items_url(bucket)

        expect { post endpoint, params, header(user) }.
          to change(Item, :count).by(1)
        expect(response.status).to eq(201)
      end

      it "does not create the bucket list when a non unique name is given" do
        bucket = user.bucket_lists.first
        params = bucket.items.first.attributes
        endpoint = api_v1_bucketlist_items_url(bucket)

        expect { post endpoint, params, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(422)
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

  describe "PUT /bucketlists/:bucketlist_id/items/:id" do
    context "as an authenticated user with valid bucketlist id and item id" do
      it "updates the bucketlist item" do
        route_params = { bucketlist_id: 1, id: 1 }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(json_response[:name]).to eq(params[:name])
        expect(response.status).to eq(200)
      end
    end

    context "as an authenticated user with valid bucket and invalid item id" do
      it "responds with not found status" do
        route_params = { bucketlist_id: 1, id: "invalid" }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an authenticated user with invalid bucketlist id" do
      it "responds with not found status" do
        route_params = { bucketlist_id: "invalid", id: 1 }
        params = { name: "Name", done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(404)
      end
    end

    context "as an authenticated user with a used item name" do
      it "responds with errors" do
        route_params = { bucketlist_id: 1, id: 1 }
        params = { name: user.bucket_lists.first.items.last.name, done: false }
        put api_v1_bucketlist_item_url(route_params), params, header(user)

        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /bucketlists/:bucketlist_id/items/:id" do
    context "as an authenticated user with valid bucketlist id and item id" do
      it "removes the bucketlist item" do
        params = { bucketlist_id: 1, id: 1 }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to change(Item, :count).by(-1)
        expect(response.status).to eq(204)
      end

      it "returns a 500 when error is encountered while deletind" do
        params = { bucketlist_id: 1, id: 1 }
        allow_any_instance_of(Item).to receive(:destroy).and_return(false)
        delete api_v1_bucketlist_item_url(params), {}, header(user)

        expect(response.status).to eq(500)
      end
    end

    context "as an authenticated user with invalid bucketlist id" do
      it "returns a 404 status" do
        params = { bucketlist_id: "invalid", id: 1 }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(404)
      end
    end

    context "as an authenticated user with invalid item id" do
      it "returns a 404 status" do
        params = { bucketlist_id: 1, id: "invalid" }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "returns a 401 status" do
        params = { bucketlist_id: 1, id: 1 }
        delete api_v1_bucketlist_item_url(params), {}

        expect(response.status).to eq(401)
      end
    end
  end
end
