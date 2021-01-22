RSpec.describe "Hydra sign-in flow" do
  describe "GET /sign-in" do
    it "renders the form" do
      stub_hydra_get_login_request
      get "/sign-in"
      expect(response).to have_http_status(:ok)
    end

    context "Hydra says to skip auth" do
      before { stub_hydra_get_login_request(response: { skip: true }) }

      it "accepts and redirects" do
        stub_hydra_accept_login_request(response: { redirect_to: "/redirect" })
        get "/sign-in"
        expect(response).to redirect_to("/redirect")
      end
    end

    context "Hydra rejects the login challenge" do
      before { stub_hydra_get_login_request(status: 404) }

      it "returns a 400" do
        get "/sign-in"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "POST /sign-in" do
    context "the credentials are good" do
      before do
        stub_hydra_get_login_request
        stub_internal_check_user_credentials(response: { status: :ok })
      end

      it "accepts and redirects" do
        stub_hydra_accept_login_request(response: { redirect_to: "/redirect" })
        post "/sign-in", params: { email: "email", password: "password" }
        expect(response).to redirect_to("/redirect")
      end

      context "Hydra rejects the login challenge" do
        before { stub_hydra_accept_login_request(status: 404) }

        it "returns a 400" do
          post "/sign-in", params: { email: "email", password: "password" }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context "the credentials are bad" do
      before do
        stub_hydra_get_login_request
        stub_internal_check_user_credentials(status: 200, response: { status: :too_many_attempts })
      end

      it "renders the form" do
        post "/sign-in", params: { email: "email", password: "password" }
        expect(response).to have_http_status(:ok)
      end
    end

    context "Hydra rejects the login challenge" do
      before { stub_hydra_get_login_request(status: 404) }

      it "returns a 400" do
        post "/sign-in"
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "internal-api returns an unexpected 4xx error" do
      before do
        stub_hydra_get_login_request
        stub_internal_check_user_credentials(status: 403)
      end

      it "returns a 500" do
        post "/sign-in", params: { email: "email", password: "password" }
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "GET /sign-in/back" do
    it "rejects and redirects" do
      stub_hydra_reject_login_request(response: { redirect_to: "/redirect" })
      get "/sign-in/back"
      expect(response).to redirect_to("/redirect")
    end

    context "Hydra rejects the login challenge" do
      before { stub_hydra_reject_login_request(status: 404) }

      it "returns a 400" do
        get "/sign-in/back"
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
