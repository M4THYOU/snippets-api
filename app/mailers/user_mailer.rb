class UserMailer < ApplicationMailer
  default from: 'mathyou.wolfe@gmail.com'

  def base_url
    if Rails.env.production?
      'https://qwaked.com/'
    else
      'http://localhost:4000/'
    end
  end

  def register_confirm
    @user = params[:user]
    @url = base_url + 'register/' + @user.confirm_token
    mail(to: @user.email, subject: 'Snippets email confirmation')
  end

  def account_invite
    @user = params[:user]
    @inviter = params[:from_user]
    @url = base_url + 'register'
    mail(to: @user.email, subject: 'Snippets Invitation')
  end

  def note_invite
    @user = params[:user]
    @inviter = params[:from_user]
    @url = base_url + 'login'
    mail(to: @user.email, subject: 'Snippets Invitation')
  end

end
