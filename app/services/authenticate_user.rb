class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  # creates a token for the given user.
  def call
    JsonWebToken.encode(user_id: user.id) if user&.is_active
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user&.authenticate(password) && !user.is_invited # user exists and is authenticated AND is not an invitation

    errors.add :user_authentication, 'invalid credentials'
    nil
  end

end
