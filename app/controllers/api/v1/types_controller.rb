module Api
  module V1
    class TypesController < ApplicationController

      def index
        types = Type.order('name')
        render json: {status: 'SUCCESS', message: 'Loaded types', data: types}, status: :ok
      end

    end
  end
end
