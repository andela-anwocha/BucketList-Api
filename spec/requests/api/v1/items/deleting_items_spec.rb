require "rails_helper"

RSpec.describe "Deleting BucketList Items", type: :request do
  let(:user) { create(:user) }
  before { create(:item, bucket_list: user.bucket_lists.first) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist_id and item_id" do
      it "removes the bucketlist item" do
        params = { bucketlist_id: 1, id: 1 }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to change(Item, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context "with a valid bucketlist_id and an invalid item_id" do
      it "responds with a 404 http status" do
        params = { bucketlist_id: 1, id: "invalid" }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(404)
      end
    end

    context "with an invalid bucketlist_id and valid item_id" do
      it "responds with a 404 http status" do
        params = { bucketlist_id: "invalid", id: 1 }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(404)
      end
    end

    context "with an invalid bucketlist_id and invalid item_id" do
      it "responds with a 404 http status" do
        params = { bucketlist_id: "invalid", id: "invalid" }

        expect { delete api_v1_bucketlist_item_url(params), {}, header(user) }.
          to_not change(Item, :count)
        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a http 401 status error" do
      params = { bucketlist_id: 1, id: 1 }
      delete api_v1_bucketlist_item_url(params), {}

      expect(response.status).to eq(401)
    end
  end
end
