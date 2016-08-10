require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user_attributes) { attributes_for(:user) }

  describe "POST /users" do
    context "when all required information is provided" do
      it "creates user" do
        expect { post api_v1_users_path, user_attributes }.
          to change(User, :count).by(1)

        expect(response.status).to eq(201)
      end
    end

    context "when all required information is not provided" do
      it "does not create user" do
        expect { post api_v1_users_path, name: "Name" }.
          to_not change(User, :count)

        expect(response.status).to eq(422)
      end
    end
  end

end
