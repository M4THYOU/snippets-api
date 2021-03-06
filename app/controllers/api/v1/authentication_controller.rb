module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request

      # post
      def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])
        if command.success? && command.result.present?
          render json: { auth_token: command.result }
        elsif command.success? # account not activated yet.
          error = { 'user_authentication': 'Please confirm your email address.', 'confirm_email': true }
          # command.errors.error = { 'user_authentication': 'Please confirm your email address.' }
          # command.errors.error['user_authentication'] = 'Please confirm your email address.'
          render json: { error: error }, status: :forbidden
        else
          render json: { error: command.errors }, status: :unauthorized
        end
      end

      # get
      def verify
        current_user = AuthorizeApiRequest.call(request.headers).result
        is_authorized = false
        is_authorized = true if current_user
        user = safe_user current_user
        render json: { authorized: is_authorized, user: user }
      end

      private

      def safe_user(user)
        if user
          {
            email: user.email,
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name
          }
        end
      end

    end
  end
end


