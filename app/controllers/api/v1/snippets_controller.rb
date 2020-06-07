require 'json'

module Api
  module V1
    class SnippetsController < ApplicationController

      def index
        snippets = Snippet.order('updated_at DESC').limit(50)
        response = RenderJson.success 'Loaded Snippets', snippets
        render json: response, status: :ok
      end

      def show
        snippet = Snippet.find(params[:id])
        response = RenderJson.success 'Loaded snippet', snippet
        render json: response, status: :ok
      end

      def create
        snippet = Snippet.new(snippet_params)
        snippet[:created_by_uid] = @current_user.id
        if snippet.save
          response = RenderJson.success 'Saved snippet', snippet
          status = :ok
        else
          response = RenderJson.error 'Snippet not saved', snippet.errors
          status = :unprocessable_entity
        end
        render json: response, status: status
      end

      def update
        snippet = Snippet.find(params[:id])
        if snippet.created_by_uid != @current_user.id
          response = RenderJson.error 'Invalid permissions', nil
          status = :unauthorized
        elsif snippet.update_attributes(snippet_params)
          response = RenderJson.success 'Updated snippet', snippet
          status = :ok
        else
          response = RenderJson.error 'Snippet not updated', snippet.errors
          status = :unprocessable_entity
        end
        render json: response, status: status
      end

      def destroy
        snippet = Snippet.find(params[:id])
        if snippet.created_by_uid == @current_user.id
          snippet.destroy
          response = RenderJson.success 'Deleted snippet', snippet
          status = :ok
        else
          response = RenderJson.error 'Invalid permissions', nil
          status = :unauthorized
        end
        render json: response, status: status
      end

      private

      def snippet_params
        params.permit(:title, :snippet_type, :course, :raw, :is_title_math)
      end

    end
  end
end

