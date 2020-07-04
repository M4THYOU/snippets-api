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
        if create_pages(pages, group.id, title, course, uid)
          response = RenderJson.success 'Saved lesson', { group_id: group.id }
          status = :ok
        end
        render json: response, status: status
      end

      def update
        response = RenderJson.error 'Lesson not updated', {}
        status = :unprocessable_entity

        uid = @current_user.id
        group_id = params[:id]

        roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, uid, Rails.configuration.x.u_role_types.lesson_owner, 0])
        unless roles.empty?
          title = lesson_update_params[:title]
          course = lesson_update_params[:course]
          pages = lesson_update_params[:pages]

          Lesson.where(['group_id = ?', group_id]).delete_all
          if create_pages(pages, group_id, title, course, uid)
            response = RenderJson.success 'Updated lesson', { group_id: group_id }
            status = :ok
          end
        end

        render json: response, status: status
      end

      def destroy
        response = RenderJson.error 'Lesson not deleted', {}
        status = :unprocessable_entity

        uid = @current_user.id
        group_id = params[:id]

        roles = URole.where(['group_id = ? and uid = ? and role_type = ? and is_revoked = ?', group_id, uid, Rails.configuration.x.u_role_types.lesson_owner, 0])
        unless roles.empty?
          URole.where(['group_id = ?', group_id]).update_all(is_revoked: 1)
          Lesson.where(['group_id = ?', group_id]).delete_all
          UGroup.delete(group_id)
          response = RenderJson.success 'Lessons successfully deleted', { group_id: group_id }
          status = :ok
        end
        render json: response, status: status
      end

      private

      def lesson_params
        params.permit(:title, :course, pages: %i[group_order canvas group_id])
      end
      
      def lesson_update_params
        params.permit(:title, :course, pages: %i[group_order canvas group_id created_at])
      end

      def create_pages(pages, group_id, title, course, uid)
        success = false
        pages.each do |page|
          lesson = Lesson.new(page)
          lesson[:created_by_uid] = uid
          lesson[:group_id] = group_id
          lesson[:title] = title
          lesson[:course] = course

          success = true if lesson.save
        end
        success
      end

    end
  end
end
