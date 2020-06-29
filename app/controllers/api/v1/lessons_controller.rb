module Api
  module V1
    class LessonsController < ApplicationController
      def index
        uid = @current_user.id
        lessons = LessonsByUid.order('updated_at DESC').where(['uid = ? and group_order = ?', uid, 1])
        response = RenderJson.success 'Loaded lessons', lessons
        render json: response, status: :ok
      end

      def show
        uid = @current_user.id
        lessons = LessonsByUid.order('group_order ASC').where(['uid = ? and group_id = ?', uid, params[:id]])
        response = RenderJson.success 'Loaded lessons', lessons
        render json: response, status: :ok
      end

      def create
        response = RenderJson.error 'Lesson not saved', {}
        status = :unprocessable_entity

        uid = @current_user.id
        title = lesson_params[:title]
        course = lesson_params[:course]
        pages = lesson_params[:pages]
        # create group
        group_config = { group_type: Rails.configuration.x.u_group_types.lesson, created_by_uid: uid }
        group = UGroup.create(group_config)
        # create roles
        # URole.create({role_type: Rails.configuration.x.u_role_types.lesson_member, uid: uid, group_id: group.id, created_by_uid: uid})
        URole.create({role_type: Rails.configuration.x.u_role_types.lesson_owner, uid: uid, group_id: group.id, created_by_uid: uid})
        # create lessons
        pages.each do |page|
          lesson = Lesson.new(page)
          lesson[:created_by_uid] = uid
          lesson[:group_id] = group.id
          lesson[:title] = title
          lesson[:course] = course
          if lesson.save
            response = RenderJson.success 'Saved lesson', {group_id: group.id}
            status = :ok
          end
        end
        render json: response, status: status
      end

      def update

      end

      def destroy; end

      private

      def lesson_params
        params.permit(:title, :course, pages: %i[group_order canvas group_id])
      end

    end
  end
end
