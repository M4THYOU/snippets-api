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
        unless User.select(uid).role_action?(uid, group_id, Rails.configuration.x.u_role_types.lesson_owner)
          render json: response, status: status
          return
        end

        user = User.use_index('email_UNIQUE').where(['email = ?', email])
        if user
          puts 'a' which one is running???
          # just add role
        else
          invitation = Invitation.use_index('email_UNIQUE').where(['email = ? and used_at IS ?', email, nil])
          if invitation
            puts 'b'
            # add it to the meta field
          else
            puts 'c'
            hash = SecureRandom.hex
            puts hash
          end
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
