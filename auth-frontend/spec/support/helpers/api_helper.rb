module ApiHelper
  def stub_hydra_get_login_request(login_challenge: nil, **kwargs)
    params = { login_challenge: login_challenge }.compact
    stub_hydra_api_call(:get, OryHydraClient::GET_LOGIN_REQUEST_PATH, params: params, **kwargs)
  end

  def stub_hydra_accept_login_request(login_challenge: nil, subject: nil, **kwargs)
    params = { login_challenge: login_challenge }.compact
    payload = { subject: subject, remember: "true", remember_for: OryHydraClient::SESSION_DURATION.to_s }.compact
    stub_hydra_api_call(:put, OryHydraClient::ACCEPT_LOGIN_REQUEST_PATH, params: params, payload: payload, **kwargs)
  end

  def stub_hydra_reject_login_request(login_challenge: nil, **kwargs)
    params = { login_challenge: login_challenge }.compact
    stub_hydra_api_call(:put, OryHydraClient::REJECT_LOGIN_REQUEST_PATH, params: params, **kwargs)
  end

  def stub_hydra_api_call(method, path, **kwargs)
    stub_json_api_call(method, "#{ENV['HYDRA_ADMIN_API_URL']}#{path}", **kwargs)
  end

  def stub_internal_check_user_credentials(email: nil, password: nil, **kwargs)
    payload = { email: email, password: password }.compact
    stub_internal_api_call(:post, InternalApiClient::CHECK_USER_CREDENTIALS_PATH, payload: payload, **kwargs)
  end

  def stub_internal_api_call(method, path, **kwargs)
    stub_json_api_call(method, "#{ENV['INTERNAL_API_URL']}#{path}", **kwargs)
  end

  def stub_json_api_call(method, url, params: nil, payload: nil, status: nil, response: nil, fuzzy: true)
    if fuzzy
      params = hash_including(params || {})
      payload = hash_including(payload || {})
    end

    stub_request(method, url)
      .with(query: params, body: payload, headers: { accept: "application/json" })
      .to_return(status: status || 200, body: (response || {}).to_json)
  end
end

RSpec.configuration.send :include, ApiHelper
