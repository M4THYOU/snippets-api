module Api
  module V1
    class SearchIndicesController < ApplicationController
      include Search

      def index
        query = search_params[:query]
        limit = search_params[:limit].to_i

        result = Search.search query
        lim_result = result.first limit
        render json: {status: 'SUCCESS', message: 'Loaded snippets', data: lim_result}, status: :ok
      end

      def search_params
        params.permit(:query, :limit)
      end

    end
  end
end
