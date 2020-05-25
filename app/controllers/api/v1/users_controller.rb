require 'json'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :validate_params
      skip_before_action :authenticate_request, only: [:create]

      def create
        if @is_valid
          user = User.new(user_params)
          if user.save
            render json: { status: 'SUCCESS', message: 'Saved user', data: user }, status: :ok
          else
            render json: {
              status: 'ERROR',
              message: 'Error saving user.',
              data: user.errors
            }, status: :unprocessable_entity
          end
        else
          render json: {
            status: 'ERROR',
            message: 'Invalid fields.',
            data: nil
          }, status: :unprocessable_entity
        end
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


