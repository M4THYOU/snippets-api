require 'json'

module Api
  module V1
    class NotesController < ApplicationController
      include Indexing

      def index
        new_params = note_params
        snippet_id = new_params['snippet_id']
        notes = Note.where(['snippet_id = ?', snippet_id])

        response = RenderJson.success 'Loaded notes', notes
        render json: response, status: :ok
      end

      def create
        new_params = note_params
        snippet_id = new_params['snippet_id']
        snippet = Snippet.find(snippet_id)
        notes = new_params['notes']
        status = :ok
        if notes.length == 1
          # if only creating 1 note.
          note = create_single_note(snippet_id, notes[0].to_h)
          if note.save
            response = RenderJson.success 'Saved note', note
            Indexing.reindex_single snippet
          else
            response = RenderJson.error 'Note not saved', []
            status = :unprocessable_entity
          end

        else

          # if creating multiple notes.
          had_error = false
          notes.each do |text|
            unless create_single_note(snippet_id, text.to_h)
              had_error = true
            end
          end
          if had_error
            response = RenderJson.error '1+ notes not saved', []
            status = :unprocessable_entity
          else
            response = RenderJson.success 'Saved notes', []
            Indexing.reindex_single snippet
          end
        end
        render json: response, status: status
      end

      def destroy
        note = Note.find(params[:id])
        snippet = Snippet.find(note.snippet_id)
        if note.created_by_uid == @current_user.id
          note.destroy
          response = RenderJson.success 'Deleted note', note
          status = :ok
          Indexing.reindex_single snippet
        else
          response = RenderJson.error 'Invalid permissions', note.errors
          status = :unauthorized
        end
        render json: response, status: status
      end

      private

      def note_params
        params.permit(:snippet_id, notes: [raw: [ :isMath, :value ]])
      end

      def create_single_note(snippet_id, text)
        new_note = {
            snippet_id: snippet_id,
            text: text.to_json,
            created_by_uid: @current_user.id
        }
        note = Note.new(new_note)
        if note.save
          note
        else
          false
        end
      end

    end
  end
end


