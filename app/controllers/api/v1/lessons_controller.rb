module Api
  module V1
    class LessonsController < ApplicationController
      def index
        uid = @current_user.id
        lessons = LessonsByUid.order('updated_at DESC').where(['uid = ?', uid])
        response = RenderJson.success 'Loaded lessons', lessons
        render json: response, status: :ok
      end

      def show; end

      def create
        uid = @current_user.id
        # create group
        group_config = { group_type: Rails.configuration.x.u_group_types.lesson, created_by_uid: uid }
        group = UGroup.create(group_config)
        # create roles
        # URole.create({role_type: Rails.configuration.x.u_role_types.lesson_member, uid: uid, group_id: group.id, created_by_uid: uid})
        URole.create({role_type: Rails.configuration.x.u_role_types.lesson_owner, uid: uid, group_id: group.id, created_by_uid: uid})
        # # create lesson
        lesson = Lesson.new(lesson_params)
        lesson[:created_by_uid] = uid
        lesson[:group_id] = group.id
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
