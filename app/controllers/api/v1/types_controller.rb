module Api
  module V1
    class TypesController < ApplicationController

      def index
        types = Type.order('name')
        response = RenderJson.success 'Loaded types', types
        render json: response, status: :ok
      end

    end
  end
end
