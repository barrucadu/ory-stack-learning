class SignIn::ShowInteractor < SignIn::BaseInteractor
  def call
    fetch_challenge!
    accept_if_skip
  end

private

  def accept_if_skip
    accept_challenge if context.skip?
  end
end
