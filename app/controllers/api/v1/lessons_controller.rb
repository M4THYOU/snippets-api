module Api
  module V1
    class LessonsController < ApplicationController
      def index; end

      def show; end

      def create
        lesson = Lesson.new(lesson_params)
        lesson[:created_by_uid] = @current_user.id
        if lesson.save
          response = RenderJson.success 'Saved lesson', lesson
          status = :ok
        else
          response = RenderJson.error 'Lesson not saved', lesson.errors
          status = :unprocessable_entity
        end
        render json: response, status: status
      end

      def update; end

      def destroy; end

      private

      def lesson_params
        params.permit(:title, :course, :canvas)
      end

    end
  end
end
