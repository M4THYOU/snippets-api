require 'json'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :validate_params
      skip_before_action :authenticate_request, only: [:create]

      def create
        if @is_valid
          user = User.new(user_params)
          status = :unprocessable_entity
          if user.save
            response = RenderJson.success 'Saved user', user
            status = :ok
          else
            response = RenderJson.error 'Error saving user', user.errors
          end
        else
          response = RenderJson.error 'Invalid fields', nil
        end
        render json: response, status: status
      end
      
      def update; end

      private

      def validate_params
        @is_valid = true
        @is_valid = params[:email].present? if @is_valid
        puts 'email', @is_valid
        @is_valid = params[:first_name].present? if @is_valid
        puts 'first_name', @is_valid
        @is_valid = params[:last_name].present? if @is_valid
        puts 'last_name', @is_valid
        @is_valid = params[:password].present? if @is_valid
        puts 'password', @is_valid
        @is_valid = params[:password_confirmation].present? if @is_valid
        puts 'confirm_password', @is_valid
        @is_valid = (params[:password] == params[:password_confirmation]) if @is_valid
        puts 'password == confirm_password', @is_valid
        @is_valid = (params[:does_agree].present? && params[:does_agree]) if @is_valid
        puts 'does_agree', @is_valid
      end

      def user_params
        params.permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end

    end
  end
end


