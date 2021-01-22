class SignIn::BackInteractor < SignIn::BaseInteractor
  def call
    reject_challenge
  end

private

  def reject_challenge
    context.redirect_to = OryHydraClient.reject_login_request(
      login_challenge: context.login_challenge_id,
    )[:redirect_to]
  rescue StandardError
    context.fail!(hydra_api_error?: true)
  end
end
