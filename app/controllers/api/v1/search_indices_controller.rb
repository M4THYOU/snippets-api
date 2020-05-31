module Api
  module V1
    class SearchIndicesController < ApplicationController

      def index
        # uid = @current_user.id
        puts params
        puts search_params
        # snippets = Snippet.where(['created_by_uid = ?', uid]).order('updated_at DESC')
        render json: {status: 'SUCCESS', message: 'Loaded snippets', data: nil}, status: :ok
      end

      def search_params
        params.permit(raw: [ :isMath, :value ])
      end

    end
  end
end
