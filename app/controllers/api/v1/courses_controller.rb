module Api
  module V1
    class CoursesController < ApplicationController

      def index
        courses = Course.order('code')
        response = RenderJson.success 'Loaded courses', courses
        render json: response, status: :ok
      end

    end
  end
end

