require "rails_helper"

RSpec.describe "Deleting BucketLists", type: :request do
  let(:user) { create(:user) }
  before { create(:bucket_list, user: user) }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "removes the bucket list" do
        valid_id = { id: BucketList.first.id }

        expect { delete api_v1_bucketlist_url(valid_id), {}, header(user) }.
          to change(BucketList, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context "with an invalid bucketlist id" do
      it "does not remove the bucketlist" do
        invalid_id = { id: "invalid" }

        expect { delete api_v1_bucketlist_url(invalid_id), {}, header(user) }.
          to_not change(BucketList, :count)
        expect(response.status).to eq(404)
      end
    end
  end

  context "as an unauthenticated user" do
    it "does not remove bucketlist" do
      valid_id = { id: BucketList.first.id }

      expect { delete api_v1_bucketlist_url(valid_id), {} }.
        to_not change(BucketList, :count)
      expect(response.status).to eq(401)
    end
  end
end
