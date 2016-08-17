require "rails_helper"

RSpec.describe "Listing BucketLists", type: :request do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:bucket_list) }

  context "as an authenticated user" do
    before { login_user(user) }
    context "when bucketlists are present" do
      it "returns all bucket lists" do
        get api_v1_bucketlists_url, {}, header(user)

        expect(json_response.count).to eq(user.bucket_lists.count)
        expect(response.status).to eq(200)
      end
    end

    context "when bucketlists are not found" do
      it "returns a 'No Bucket List found'" do
        user.bucket_lists.destroy_all

        get api_v1_bucketlists_url, {}, header(user)
        expect(json_response[:message]).to eq Message.no_bucket
        expect(response.status).to eq(200)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 http status code" do
      get api_v1_bucketlists_url, {}

      expect(response.status).to eq(401)
    end
  end

  context "as a logged in user with invalid token" do
    it "returns an error message with a 401 http status code" do
      get api_v1_bucketlists_url, {}, invalid_header(user)

      expect(json_response[:error]).to eq Message.invalid_token
      expect(response.status).to eq(401)
    end
  end
end
