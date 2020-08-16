require 'json'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :validate_params, only: [:create]
      skip_before_action :authenticate_request, only: %i[create confirm_email send_confirm_email]

      def create
        if @is_valid
          status = :unprocessable_entity
          user = User.find_by_email(user_params[:email])

          if user.nil?
            user = User.new(user_params)
          else
            user.assign_attributes(user_params)
            user.is_invited = false
          end
          if user.save
            UserMailer.with(user: user).register_confirm.deliver_later
            response = RenderJson.success 'Saved user', user
            status = :ok
          else
            response = RenderJson.error 'Error saving user', user.errors
          end
        else
          response = RenderJson.error 'Invalid fields', nil
          status = :unprocessable_entity
        end
        render json: response, status: status
      end
      
      def confirm_email
        user = User.find_by_confirm_token(params[:id])
        if user
          user.email_activate
          response = RenderJson.success 'Email confirmed', user
          status = :ok
        else
          response = RenderJson.error 'User does not exist', user
          status = :not_found
        end
        render json: response, status: status
      end

      def send_confirm_email
        user = User.find_by_email(params[:email])
        if user
          UserMailer.with(user: user).register_confirm.deliver
          response = RenderJson.success 'Email sent', user
          status = :ok
        else
          response = RenderJson.error 'User does not exist', user
          status = :not_found
        end
        render json: response, status: status
      end

      private

      def validate_params
        @is_valid = true
        @is_valid = params[:email].present? if @is_valid
        @is_valid = params[:first_name].present? if @is_valid
        @is_valid = params[:last_name].present? if @is_valid
        @is_valid = params[:password].present? if @is_valid
        @is_valid = params[:password_confirmation].present? if @is_valid
        @is_valid = (params[:password] == params[:password_confirmation]) if @is_valid
        @is_valid = (params[:does_agree].present? && params[:does_agree]) if @is_valid
      end

      def user_params
        params.permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end

    end
  end
end


