require "rails_helper"

RSpec.describe "Showing a BucketList", type: :request do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:bucket_list) }

  context "as an authenticated user" do
    before { login_user(user) }
    context "with a valid bucketlist id" do
      it "returns the specific bucketlist" do
        bucket_id = { id: user.bucket_lists.first.id }
        get api_v1_bucketlist_url(bucket_id), {}, header(user)

        expect(json_response[:name]).to eq(user.bucket_lists.first.name)
        expect(response.status).to eq(200)
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a 404 http status code" do
        get api_v1_bucketlist_url(id: "invalid_id"), {}, header(user)

        expect(json_response[:error]).to eq("Bucket List Not found")
        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a http 401 status code" do
      get api_v1_bucketlist_url(user.bucket_lists.first), {}

      expect(response.status).to eq(401)
    end
  end
end
