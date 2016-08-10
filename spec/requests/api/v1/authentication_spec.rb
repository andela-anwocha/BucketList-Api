require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }
  describe "POST /api/v1/oauth/login" do
    context "when valid attributes are passed in" do
      it "signs in user" do
        login_user(user)
        user.reload

        expect(response.status).to eq(200)
      end
    end

    context "when invalid attributes are passed in" do
      it "responds with a 401 status" do
        login_invalid_user

        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /auth/logout" do
    before { login_user(user) }

    context "with a valid authorization header" do
      it "logs the user out and destroys the users token" do
        get api_v1_logout_path, {}, header(user)
        user.reload

        expect(user.token).to be_nil
      end
    end

    context "with an invalid authorization header" do
      it "does not logout the user" do
        get api_v1_logout_path, {}, invalid_header(user)

        expect(user.token).to_not be_nil
      end
    end
  end
end
