require 'json'

module Api
  module V1
    class SnippetsController < ApplicationController

      def index
        snippets = Snippet.order('created_at DESC')
        render json: {status: 'SUCCESS', message: 'Loaded articles', data: snippets}, status: :ok
      end

      def create
        snippet = Snippet.new(snippet_params)
        if snippet.save
          render json: { status: 'SUCCESS', message: 'Saved snippet', data: snippet }, status: :ok
        else
          render json: {
            status: 'ERROR',
            message: 'Article not saved',
            data: snippet.errors
          }, status: :unprocessable_entity
        end
      end

      private

      def snippet_params
        params.permit(:title, :snippet_type, :course, :raw, :notes)
      end

    end
  end
end

