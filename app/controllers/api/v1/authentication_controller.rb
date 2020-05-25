module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request

      # post
      def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])
        if command.success?
          render json: { auth_token: command.result }
        else
          render json: { error: command.errors }, status: :unauthorized
        end
      end

      # get
      def verify
        current_user = AuthorizeApiRequest.call(request.headers).result
        is_authorized = false
        is_authorized = true if current_user
        render json: { authorized: is_authorized }
      end

    end
  end
end

