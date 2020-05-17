require 'json'

module Api
  module V1
    class SnippetsController < ApplicationController

      def index
        snippets = Snippet.order('updated_at ASC')
        render json: {status: 'SUCCESS', message: 'Loaded snippets', data: snippets}, status: :ok
      end

      def show
        snippet = Snippet.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Loaded snippet', data: snippet}, status: :ok
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
        params.permit(:title, :snippet_type, :course, :raw)
      end

    end
  end
end

