class UserMailer < ApplicationMailer
  default from: 'mathyou.wolfe@gmail.com'

  def confirm_email_user_url(token)
    if Rails.env.production?
      'https://qwaked.com/register/' + token
    else
      'http://localhost:4000/register/' + token
    end
  end

  def register_confirm
    puts 'sending email'
    @user = params[:user]
    @url = confirm_email_user_url(@user.confirm_token)
    mail(to: @user.email, subject: 'Snippets email confirmation')
  end

end
