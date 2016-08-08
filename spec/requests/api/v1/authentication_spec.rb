require "rails_helper"

RSpec.describe "AuthenticationController", type: :request do
  describe "POST /api/v1/oauth/login" do
    context "when valid attributes are passed in" do
      it "signs in user" do
        user = create(:user)
        login_user(user)

        expect(response.status).to eq(201)
      end
    end

    context "when invalid attributes are passed in" do
      it "responds with a 401 status" do
        login_invalid_user

        expect(response.status).to eq(401)
      end
    end
  end
end
