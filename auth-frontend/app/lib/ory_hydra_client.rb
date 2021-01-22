# frozen_string_literal: true

module OryHydraClient
  SESSION_DURATION = 30.minutes

  GET_LOGIN_REQUEST_PATH = "/oauth2/auth/requests/login"
  ACCEPT_LOGIN_REQUEST_PATH = "/oauth2/auth/requests/login/accept"
  REJECT_LOGIN_REQUEST_PATH = "/oauth2/auth/requests/login/reject"

  def self.get_login_request(login_challenge:)
    api_do(
      :get,
      GET_LOGIN_REQUEST_PATH,
      params: {
        login_challenge: login_challenge,
      },
    )
  end

  def self.accept_login_request(login_challenge:, subject:)
    api_do(
      :put,
      ACCEPT_LOGIN_REQUEST_PATH,
      params: {
        login_challenge: login_challenge,
      },
      payload: {
        subject: subject,
        remember: true,
        remember_for: SESSION_DURATION,
      },
    )
  end

  def self.reject_login_request(login_challenge:)
    api_do(
      :put,
      REJECT_LOGIN_REQUEST_PATH,
      params: {
        login_challenge: login_challenge,
      },
    )
  end

  def self.api_do(method, path, params: {}, payload: {})
    JsonApiClient.api_do(
      method,
      ENV.fetch("HYDRA_ADMIN_API_URL") + path,
      params: params,
      payload: payload,
    )
  end
end
