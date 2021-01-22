RSpec.describe SignIn::CreateInteractor do
  before { stub_hydra_get_login_request }

  let(:result) { described_class.call(params: params) }
  let(:params) { { email: "email", password: "password" } }

  it "reports an internal-api 404 as a missing user error" do
    stub_internal_check_user_credentials(status: 404)

    expect(result.errors).to eq({ email: :no_such_user })
  end

  it "reports an internal-api 500 as an app error" do
    stub_internal_check_user_credentials(status: 500)

    expect(result.internal_api_error?).to be(true)
  end

  context "internal-api returns a credential error" do
    it "attributes email errors to the right field" do
      SignIn::CreateInteractor::EMAIL_FAILURE_REASONS.each do |reason|
        stub_internal_check_user_credentials(response: { status: reason })
        result = described_class.call(params: params)
        expect(result.errors).to eq({ email: reason })
      end
    end

    it "attributes password errors to the right field" do
      SignIn::CreateInteractor::PASSWORD_FAILURE_REASONS.each do |reason|
        stub_internal_check_user_credentials(response: { status: reason })
        result = described_class.call(params: params)
        expect(result.errors).to eq({ password: reason })
      end
    end

    it "reports an unknown error as an app error" do
      stub_internal_check_user_credentials(response: { status: :foo })

      expect(result.internal_api_error?).to be(true)
    end
  end

  context "with email and password not set" do
    let(:params) { {} }

    it "checks for missing credentials" do
      expect(result.errors).to eq({ email: :empty, password: :empty })
    end
  end
end
