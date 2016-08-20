require "rails_helper"

RSpec.describe "Creating BucketLists", type: :request do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:bucket_list) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "when valid attributes are provided" do
      context "with a unique bucketlist name" do
        it "creates the bucketlist" do
          expect { post api_v1_bucketlists_url, params, header(user) }.
            to change(BucketList, :count).by(1)
          expect(response.status).to eq(201)
        end
      end

      context "with a non unique bucketlist name" do
        it "does not create the bucketlist" do
          params = user.bucket_lists.first.attributes

          expect { post api_v1_bucketlists_url, params, header(user) }.
            to_not change(BucketList, :count)
          expect(response.status).to eq(422)
        end
      end
    end

    context "when invalid attributes are provided" do
      it "does not create the bucketlist" do
        invalid_params = { invalid_name: "Invalid" }

        expect { post api_v1_bucketlists_url, invalid_params, header(user) }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(422)
      end
    end
  end

  context "as an unauthenticated user" do
    it "does not create the bucketlist" do
      invalid_header = {}

      expect { post api_v1_bucketlists_url, params, invalid_header }.
        to_not change(BucketList, :count)
      expect(response.status).to eq(401)
    end
  end
end
