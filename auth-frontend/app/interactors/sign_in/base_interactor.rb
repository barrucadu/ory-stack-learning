class SignIn::BaseInteractor < ApplicationInteractor
  delegate :params,
           to: :context

protected

  def fetch_challenge!
    challenge = params[:login_challenge]

    begin
      context.hydra_response = OryHydraClient.get_login_request(login_challenge: challenge)
    rescue StandardError
      context.fail!(hydra_api_error?: true)
    end

    context.login_challenge_id = challenge
    context[:skip?] = context.hydra_response[:skip]
  end

  def accept_challenge
    context.redirect_to = OryHydraClient.accept_login_request(
      login_challenge: context.login_challenge_id,
      subject: context.hydra_response[:subject],
    )[:redirect_to]
  rescue StandardError
    context.fail!(hydra_api_error?: true)
  end
end
