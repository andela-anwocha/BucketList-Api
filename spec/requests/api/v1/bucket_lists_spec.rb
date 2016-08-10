require "rails_helper"

RSpec.describe "BucketLists", type: :request do
  let(:user) { create(:user) }

  before { login_user(user) }

  describe "POST /api/v1/bucketlists" do
    let(:params) { attributes_for(:bucket_list) }

    context "as an authenticated user with valid authorization token" do
      it "creates the bucketlist" do
        expect { post api_v1_bucketlists_url, params, header(user) }.
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
        get api_v1_bucketlists_url, {}, header(user)

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
        get api_v1_bucketlist_url(bucket_id), {}, header(user)

        expect(json_response[:name]).to eq(user.bucket_lists.first.name)
        expect(response.status).to eq(200)
      end
    end

    context "as an authenticated user with an invalid bucketlist id" do
      it "does not return the bucket list" do
        get api_v1_bucketlist_url(id: 10), {}, header(user)

        expect(json_response[:error]).to eq("Bucket List Not found")
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

  describe "PUT /api/v1/bucketlists/:id" do
    context "as an authenticated user with valid bucket_list id" do
      it "updates the bucket list" do
        params = { name: "Name" }
        put api_v1_bucketlist_url(id: 1), params, header(user)
        user.reload

        expect(user.bucket_lists.first.name).to eq(params[:name])
        expect(response.status).to eq(200)
      end
    end

    context "as an authenticated user with invalid bucket_list id" do
      it "does not update the bucket list" do
        params = { name: "Name" }
        invalid_id = { id: "invalid" }
        put api_v1_bucketlist_url(invalid_id), params, header(user)
        user.reload

        expect(user.bucket_lists.first.name).to_not eq(params[:name])
        expect(response.status).to eq(404)
      end
    end

    context "as an authenticated user with a non unique bucket name" do
      it "does not update name and returns a 422 status error" do
        params = { name: user.bucket_lists.last.name }
        valid_id = { id: 1 }
        put api_v1_bucketlist_url(valid_id), params, header(user)
        user.reload

        expect(user.bucket_lists.first.name).to_not eq(params[:name])
        expect(response.status).to eq(422)
      end
    end

    context "as an unauthenticated user" do
      it "does not update name and renders a 401 status error" do
        params = { name: user.bucket_lists.last.name }
        valid_id = { id: 1 }
        put api_v1_bucketlist_url(valid_id), params
        user.reload

        expect(user.bucket_lists.first.name).to_not eq(params[:name])
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /api/v1/bucketlists?q=" do
    context "as an authenticated user" do
      it "returns all bucketlists matching the search query" do
        search_query = { q: "Humanitarian" }
        get api_v1_bucketlists_url, search_query, header(user)

        search_results = json_response.map { |object| object[:name] }
        expect(search_results).to match_array(user.bucket_lists.pluck(:name))
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

  describe "GET /api/v1/bucketlists?page=*&limit=*" do
    context "as an authenticated user with page and limit parameter" do
      it "returns all bucketlists with the specified criteria" do
        pagination_query = { page: 1, limit: 1 }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(1)
      end
    end

    context "as an authenticated user with page and no limit parameter" do
      it "returns all bucketlists" do
        pagination_query = { page: 1 }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(user.bucket_lists.count)
      end
    end

    context "as an authenticated user with limit and no page parameter" do
      it "returns all bucketlists limited by the limit parameter" do
        pagination_query = { page: nil, limit: 1 }
        get api_v1_bucketlists_url, pagination_query, header(user)

        expect(json_response.count).to eq(1)
      end
    end

    context "as an unauthenticated user" do
      it "returns a 401 status error" do
        pagination_query = { page: 1, limit: 1 }
        get api_v1_bucketlists_url, pagination_query

        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /api/v1/bucketlists?search=*&page=*&limit=*" do
    context "as an authenticated user" do
      it "returns all bucketlists matching the specified criteria" do
        pagination_query = { search: "Humanitarian", page: 1, limit: 1 }
        get api_v1_bucketlists_url, pagination_query, header(user)
                
        expect(json_response[0].slice(:name).values).
          to match_array [user.bucket_lists.first.name]
        expect(response.status).to eq(200)
      end
    end

    context "as an unauthenticated user" do
      it "returns a 401 status error" do
        pagination_query = { search: "Humanitarian", page: 1, limit: 1 }
        get api_v1_bucketlists_url, pagination_query

        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /api/v1/bucketlists/:id" do
    context "as an authenticated user with a valid bucketlist id" do
      it "removes the bucket list" do
        valid_id = { id: 1 }

        expect { delete api_v1_bucketlist_url(valid_id), {}, header(user) }.
          to change(BucketList, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context "as an authenticated user with an invalid bucketlist id" do
      it "returns a 404 status" do
        invalid_id = { id: 3 }

        expect { delete api_v1_bucketlist_url(invalid_id), {}, header(user) }.
          to_not change(BucketList, :count)
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
