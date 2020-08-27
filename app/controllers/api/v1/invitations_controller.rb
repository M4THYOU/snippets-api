# frozen_string_literal: true

require 'securerandom'

module Api
  module V1
    class InvitationsController < ApplicationController
      include Indexing

      def create
        response = RenderJson.error 'Invalid permissions', {}
        status = :forbidden

        uid = @current_user.id
        email = invitation_params[:email]
        group_id = invitation_params[:group_id]
        unless User.find(uid).role_action?(group_id, Rails.configuration.x.u_role_types.owner)
          render json: response, status: status
          return
        end

        user = User.find_by_email(email)
        if user.nil?
          user = User.create({ email: email, password: '0', password_confirmation: '0', is_invited: 1 })
          user.add_role(uid, Rails.configuration.x.u_role_types.member, group_id)

          UserMailer.with(user: user, from_user: @current_user).account_invite.deliver_later

          response = RenderJson.success 'User Invited', {}
          status = :ok
        else
          user.add_role(uid, Rails.configuration.x.u_role_types.member, group_id)

          UserMailer.with(user: user, from_user: @current_user).note_invite.deliver_later

          response = RenderJson.success 'User Invited', {}
          status = :ok
        end

        render json: response, status: status
      end

      private

      def invitation_params
        params.permit(:email, :group_id)
      end

    end
  end
end
