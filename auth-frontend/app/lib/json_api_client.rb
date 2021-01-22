module JsonApiClient
  def self.api_do(method, url, params: {}, payload: {})
    resource = RestClient::Resource.new(
      url,
      headers: {
        accept: :json,
        params: params,
      },
    )

    response =
      if %i[patch post put].include? method
        resource.public_send(method, payload)
      else
        resource.public_send(method)
      end

    JSON.parse(response.body).deep_symbolize_keys
  end
end
