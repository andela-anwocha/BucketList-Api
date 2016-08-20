require "rails_helper"

describe BucketList, type: :model do
  let(:bucket1) { create(:bucket_list, name: "Humanitarian") }
  let(:bucket2) { create(:bucket_list, name: "Adventures") }
  let(:bucket3) { create(:bucket_list, name: "Fun") }

  describe "instance methods" do
    it { is_expected.to respond_to(:name) }
  end

  describe "ActiveModel Validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to belong_to(:user) }
  end

  describe ".paginate" do
    context "when bucket lists have been created" do
      it "returns a paginated bucket list" do
        expect(BucketList.paginate(1, 2)).to eq([bucket1, bucket2])
      end
    end

    context "when there are no bucket lists created" do
      it "returns an empty array" do
        expect(BucketList.paginate(1, 2)).to eq([])
      end
    end
  end

  describe ".search" do
    context "when query matches a bucket list" do
      it "returns the filtered list using the query supplied" do
        expect(BucketList.search("human")).to eq([bucket1])
      end
    end

    context "when query doesn't match a bucket list" do
      it "returns an empty array" do
        expect(BucketList.search("education")).to eq([])
      end
    end
  end

  describe ".paginate_and_search" do
    context "with empty bucket list" do
      it "returns an empty array" do
        paginated_list = BucketList.paginate_and_search(
          q: "bucket",
          page: 1,
          limit: 2
        )

        expect(paginated_list).to eq([])
      end
    end

    context "with bucket lists present" do
      it "returns the paginated and query filtered list" do
        paginated_list = BucketList.paginate_and_search(
          q: "Human",
          page: 1,
          limit: 2
        )

        expect(paginated_list).to eq([bucket1])
      end
    end
  end
end
