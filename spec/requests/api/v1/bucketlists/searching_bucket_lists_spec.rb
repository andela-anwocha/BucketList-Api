require "rails_helper"

RSpec.describe "Searching BucketLists", type: :request do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:bucket_list) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a search query provided" do
      it "returns all bucketlists matching the search query" do
        search_query = { q: "Humanitarian" }
        get api_v1_bucketlists_url, search_query, header(user)

        search_results = json_response.map { |object| object[:name] }
        expect(search_results).to match_array(user.bucket_lists.pluck(:name))
      end
    end

    context "with no search query provided" do
      it "returns all bucketlists" do
        get api_v1_bucketlists_url, {}, header(user)

        expect(json_response.count).to eq(user.bucket_lists.count)
      end
    end
  end

  context "as an unauthenticated user" do
    it "returns a 401 status error" do
      search_query = { q: "Humanitarian" }
      get api_v1_bucketlists_url, search_query

      expect(response.status).to eq(401)
    end
  end
end
