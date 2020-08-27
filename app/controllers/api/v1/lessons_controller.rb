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
        URole.create({role_type: Rails.configuration.x.u_role_types.owner, uid: uid, group_id: group.id, created_by_uid: uid})
        # create lessons
        if create_pages(pages, group.id, title, course)
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

        if User.find(uid).role_action?(group_id, Rails.configuration.x.u_role_types.owner)
          title = lesson_update_params[:title]
          course = lesson_update_params[:course]
          pages = lesson_update_params[:pages]

          if update_pages(pages, group_id, title, course)
            response = RenderJson.success 'Updated lesson', { group_id: group_id }
            status = :ok
          end

          # Lesson.where(['group_id = ?', group_id]).delete_all
          # if create_pages(pages, group_id, title, course, uid)
          #   response = RenderJson.success 'Updated lesson', { group_id: group_id }
          #   status = :ok
          # end
        end

        render json: response, status: status
      end

      def destroy
        response = RenderJson.error 'Lesson not deleted', {}
        status = :unprocessable_entity

        uid = @current_user.id
        group_id = params[:id]

        if User.find(uid).role_action?(group_id, Rails.configuration.x.u_role_types.owner)
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

      def create_pages(pages, group_id, title, course)
        success = false
        pages.each do |page|
          success = true if create_page(page, group_id, title, course)
        end
        success
      end

      def create_page(page, group_id, title, course)
        success = false
        lesson = Lesson.new(page)
        lesson[:created_by_uid] = @current_user.id
        lesson[:group_id] = group_id
        lesson[:title] = title
        lesson[:course] = course
        success = true if lesson.save
        success
      end

      def update_pages(pages, group_id, title, course)
        success = false
        lessons = Lesson.order('group_order ASC').where(['group_id = ?', group_id])
        i = 0
        while i < pages.length || i < lessons.length
          p = pages[i]
          l = lessons[i]

          if p.nil? || JSON.parse(p[:canvas])['raw_canvas'].empty? # then there exists a lesson. Delete it.
            l.delete
          elsif l.nil? # then there exists a page. Create the lesson.
            success = true if create_page(p, group_id, title, course)
          else # then there exists page and lesson. Update the lesson with p.canvas
          puts 'aaaa'
            puts p
            l.canvas = p[:canvas]
            success = true if l.save
          end
          i += 1
        end
        success
      end

    end
  end
end
