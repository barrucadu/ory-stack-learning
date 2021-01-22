class SignIn::CreateInteractor < SignIn::BaseInteractor
  EMAIL_FAILURE_REASONS = %i[
    confirmation_grace_period
    no_such_user
  ].freeze

  PASSWORD_FAILURE_REASONS = %i[
    invalid
    last_attempt
    too_many_attempts
  ].freeze

  def call
    fetch_challenge!
    check_credentials_present!
    check_credentials_correct!
    accept_challenge
  end

private

  def check_credentials_present!
    context.email = params[:email]
    context.password = params[:password]

    errors = {}
    errors[:email] = :empty if context.email.blank?
    errors[:password] = :empty if context.password.blank?

    context.fail!(errors: errors) unless errors.empty?
  end

  def check_credentials_correct!
    begin
      status = InternalApiClient.check_user_credentials(
        email: context.email,
        password: context.password,
      )[:status].to_sym
    rescue RestClient::NotFound
      context.fail!(errors: { email: :no_such_user })
    rescue StandardError
      context.fail!(internal_api_error?: true)
    end

    return if status == :ok

    if EMAIL_FAILURE_REASONS.include? status
      context.fail!(errors: { email: status })
    elsif PASSWORD_FAILURE_REASONS.include? status
      context.fail!(errors: { password: status })
    else
      context.fail!(internal_api_error?: true)
    end
  end
end
