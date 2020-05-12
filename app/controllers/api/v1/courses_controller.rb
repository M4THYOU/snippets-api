module Api
  module V1
    class CoursesController < ApplicationController

      def index
        courses = Course.order('code')
        render json: {status: 'SUCCESS', message: 'Loaded courses', data: courses}, status: :ok
      end

    end
  end
end

