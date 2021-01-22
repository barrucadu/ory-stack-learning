RSpec.describe JsonApiClient do
  describe "api_do" do
    let(:url) { "http://www.example.com/endpoint.json" }
    let(:params) { { q1: "foo", q2: "bar" } }
    let(:payload) { { p1: "baz", p2: "bat" } }

    it "parses the response as JSON" do
      expected_response = { key1: { key2: "value" } }
      stub_json_api_call(:get, url, response: expected_response)
      api_response = described_class.api_do(:get, url)
      expect(api_response).to eq(expected_response)
    end

    it "sends a payload with PATCH/POST/PUT requests" do
      %i[patch post put].each do |method|
        stub_with_payload = stub_json_api_call(method, url, params: params, payload: payload, fuzzy: false)
        stub_without_payload = stub_json_api_call(method, url, params: params, fuzzy: false)

        described_class.api_do(method, url, params: params, payload: payload)

        expect(stub_with_payload).to have_been_made
        expect(stub_without_payload).to_not have_been_made
      end
    end

    it "doesn't send a payload with GET/HEAD/DELETE requests" do
      %i[get head delete].each do |method|
        stub_with_payload = stub_json_api_call(method, url, params: params, payload: payload, fuzzy: false)
        stub_without_payload = stub_json_api_call(method, url, params: params, fuzzy: false)

        described_class.api_do(method, url, params: params, payload: payload)

        expect(stub_with_payload).to_not have_been_made
        expect(stub_without_payload).to have_been_made
      end
    end
  end
end
