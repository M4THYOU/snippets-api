module Api
  module V1
    class SearchIndicesController < ApplicationController
      include Search

      def index
        query = search_params[:query]
        Search.search query
        # snippets = Snippet.where(['created_by_uid = ?', uid]).order('updated_at DESC')
        render json: {status: 'SUCCESS', message: 'Loaded snippets', data: nil}, status: :ok
      end

      def search_params
        params.permit(:query)
      end

    end
  end
end
