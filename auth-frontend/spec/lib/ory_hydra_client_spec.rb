RSpec.describe OryHydraClient do
  describe "accept_login_request" do
    it "remembers the user" do
      stub = stub_hydra_api_call(
        :put,
        OryHydraClient::ACCEPT_LOGIN_REQUEST_PATH,
        payload: { remember: "true", remember_for: OryHydraClient::SESSION_DURATION.to_s },
      )
      described_class.accept_login_request(login_challenge: "foo", subject: "bar")
      expect(stub).to have_been_made
    end
  end
end
