require "rails_helper"

describe User, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:token) }
  end

  describe "ActiveModel Validation" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to have_many(:bucket_lists) }
  end
end
