require "rails_helper"

RSpec.describe "BucketLists", type: :request do
  let(:user) { create(:user) }
  before { login_user(user) }

  describe "POST /api/v1/bucketlists" do
    let(:params) { attributes_for(:bucket_list) }

    context "as an authenticated user with valid authorization token" do
      it "creates the bucketlist" do
        expect { post api_v1_bucketlists_url, params, auth_header(user) }.
          to change(BucketList, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context "as a logged in user with invalid authorization token" do
      it "does not create the bucketlist" do
        expect { post api_v1_bucketlists_url, params, invalid_header(user) }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(401)
      end
    end

    context "as an unauthenticated user" do
      it "does not create the bucketlist" do
        expect { post api_v1_bucketlists_url, params }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /api/v1/bucketlists" do
    context "as an authenticated user" do
      it "returns all bucket lists" do
        get api_v1_bucketlists_url, {}, auth_header(user)

        expect(json_response.count).to eq(user.bucket_lists.count)
        expect(response.status).to eq(200)
      end
    end

    context "as a logged in user with invalid token" do
      it "returns an error message" do
        get api_v1_bucketlists_url, {}, invalid_header(user)

        expect(json_response[:error]).to eq("Invalid Token")
        expect(response.status).to eq(401)
      end
    end

    context "as an unauthenticated user" do
      it "returns an error message" do
        get api_v1_bucketlists_url, {}

        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /api/v1/bucketlists/:id" do
    context "as an authenticated user with a valid bucketlist id" do
      it "returns the specific bucketlist" do
        bucket_id = { id: 1 }
        get api_v1_bucketlist_url(bucket_id), {}, auth_header(user)

        expect(json_response[:name]).to eq(user.bucket_lists.first.name)
        expect(response.status).to eq(200)
      end
    end

    context "as an authenticated user with an invalid bucketlist id" do
      it "does not return the bucket list" do
        get api_v1_bucketlist_url(id: 10), {}, auth_header(user)

        expect(json_response[:error]).to eq("Bucket List not found")
        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "does not return the bucket list" do
        get api_v1_bucketlist_url(user.bucket_lists.first), {}

        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /api/v1/bucketlists/:id" do
    context "as an authenticated user with a valid bucketlist id" do
      it "removes the bucket list" do
        valid_id = { id: 1 }

        expect do
          delete api_v1_bucketlist_url(valid_id),
                 {},
                 auth_header(user)
        end.to change(BucketList, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "as an authenticated user with an invalid bucketlist id" do
      it "returns a 404 status" do
        invalid_id = { id: 3 }

        expect do
          delete api_v1_bucketlist_url(invalid_id),
                 {},
                 auth_header(user)
        end.to_not change(BucketList, :count)

        expect(response.status).to eq(404)
      end
    end

    context "as an unauthenticated user" do
      it "does not remove bucketlist and returns a 401 status" do
        valid_id = { id: 1 }

        expect { delete api_v1_bucketlist_url(valid_id), {} }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(401)
      end
    end
  end
end
