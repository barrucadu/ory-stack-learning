# frozen_string_literal: true

module InternalApiClient
  CHECK_USER_CREDENTIALS_PATH = "/user/credentials/check"

  def self.check_user_credentials(email:, password:)
    api_do(
      :post,
      CHECK_USER_CREDENTIALS_PATH,
      payload: {
        email: email,
        password: password,
      },
    )
  end

  def self.api_do(method, path, params: {}, payload: {})
    JsonApiClient.api_do(
      method,
      ENV.fetch("INTERNAL_API_URL") + path,
      params: params,
      payload: payload,
    )
  end
end
