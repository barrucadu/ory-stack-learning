class SignInController < ApplicationController
  def show
    result = SignIn::ShowInteractor.call!(params: params)
    redirect_to result.redirect_to and return if result.skip?

    @login_challenge_id = result.login_challenge_id
  rescue Interactor::Failure
    head :bad_request
  end

  def create
    result = SignIn::CreateInteractor.call!(params: params)
    redirect_to result.redirect_to
  rescue Interactor::Failure => e
    head :bad_request and return if e.context.hydra_api_error?
    head :internal_server_error and return if e.context.internal_api_error?

    @errors = e.context.errors
    @login_challenge_id = e.context.login_challenge_id
    render :show
  end

  def back
    result = SignIn::BackInteractor.call!(params: params)
    redirect_to result.redirect_to
  rescue Interactor::Failure
    head :bad_request
  end
end
