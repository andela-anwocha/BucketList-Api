require "rails_helper"

RSpec.describe "BucketLists", type: :request do
  let(:user) { create(:user) }
  before { login_user(user) }

  describe "POST /api/v1/bucketlists" do
    context "as an authenticated user with valid authorization token" do
      it "creates the bucketlist" do
        params = { name: "Name" }
        expect { post api_v1_bucketlists_url, params, auth_header(user) }.
          to change(BucketList, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context "as a logged in user with invalid authorization token" do
      it "does not create the bucketlist" do
        params = { name: "Name" }
        expect { post api_v1_bucketlists_url, params, invalid_header(user) }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(401)
      end
    end

    context "as an unauthenticated user" do
      it "does not create the bucketlist" do
        params = { name: "Name" }
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
end
