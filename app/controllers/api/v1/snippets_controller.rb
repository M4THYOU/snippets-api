require 'json'

module Api
  module V1
    class SnippetsController < ApplicationController

      def index
        uid = @current_user.id
        snippets = Snippet.where(['created_by_uid = ?', uid]).order('updated_at DESC')
        render json: {status: 'SUCCESS', message: 'Loaded snippets', data: snippets}, status: :ok
      end

      def show
        snippet = Snippet.find(params[:id])
        if snippet.created_by_uid == @current_user.id
          render json: {status: 'SUCCESS', message: 'Loaded snippet', data: snippet}, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'You do not have permission to view this snippet',
            data: snippet.errors
          }, status: :unauthorized
        end
      end

      def create
        snippet = Snippet.new(snippet_params)
        snippet[:created_by_uid] = @current_user.id
        if snippet.save
          render json: { status: 'SUCCESS', message: 'Saved snippet', data: snippet }, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'Snippet not saved',
            data: snippet.errors
          }, status: :unprocessable_entity
        end
      end

      def update
        snippet = Snippet.find(params[:id])
        if snippet.created_by_uid != @current_user.id
          render json: {
            status: 'ERROR',
            message: 'Invalid permissions',
            data: nil
          }, status: :unauthorized
        elsif snippet.update_attributes(snippet_params)
          render json: {status: 'SUCCESS', message: 'Updated snippet', data: snippet}, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'Snippet not updated',
            data: snippet.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        snippet = Snippet.find(params[:id])
        if snippet.created_by_uid == @current_user.id
          snippet.destroy
          render json: {status: 'SUCCESS', message: 'Deleted snippet', data: snippet}, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'Invalid permissions',
            data: nil
          }, status: :unauthorized
        end
      end

      private

      def snippet_params
        params.permit(:title, :snippet_type, :course, :raw, :is_title_math)
      end

    end
  end
end

