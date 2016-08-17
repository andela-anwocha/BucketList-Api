require "rails_helper"

RSpec.describe "Paginating BucketLists", type: :request do
  let(:user) { create(:user, bucket_count: 150) }
  let(:params) { attributes_for(:bucket_list) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a page and limit parameter" do
      context "when limit > 100" do
        it "returns a maximum of 100 bucketlists" do
          pagination_query = { page: 1, limit: 120 }
          get api_v1_bucketlists_url, pagination_query, header(user)

          expect(json_response.count).to eq(100)
        end
      end

      context "when limit < 100" do
        it "returns bucketlists limited by the limit parameter" do
          pagination_query = { page: 1, limit: 50 }
          get api_v1_bucketlists_url, pagination_query, header(user)

          expect(json_response.count).to eq(50)
        end
      end
    end

    context "with a page and no limit parameter specified" do
      it "returns a default of 20 bucketlists" do
        pagination_query = { page: 1, limit: nil }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(20)
      end
    end

    context "with limit and no page parameter specified" do
      it "returns all bucketlists limited by the limit parameter" do
        pagination_query = { page: nil, limit: 1 }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(1)
      end
    end

    context "with no limit and no page parameter specified" do
      it "returns a default of 20 bucketLists starting from the first" do
        pagination_query = { page: nil, limit: nil }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(20)
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 status error" do
      pagination_query = { page: 1, limit: 1 }
      get api_v1_bucketlists_url, pagination_query

      expect(response.status).to eq(401)
    end
  end
end
