require 'json'

module Api
  module V1
    class NotesController < ApplicationController

      def index
        new_params = note_params
        snippet_id = new_params['snippet_id']
        notes = Note.where(['snippet_id = ?', snippet_id])
        render json: {status: 'SUCCESS', message: 'Loaded notes', data: notes}, status: :ok
      end

      def create
        new_params = note_params

        notes = new_params['notes']
        if notes.length == 1
          # if only creating 1 note.
          note = create_single_note(new_params['snippet_id'], notes[0])
          if note.save
            render json: { status: 'SUCCESS', message: 'Saved note', data: note }, status: :ok
          else
            render json: {
              status: 'ERROR',
              message: 'Note not saved',
              data: []
            }, status: :unprocessable_entity
          end

        else

          # if creating multiple notes.
          had_error = false
          notes.each do |text|
            unless create_single_note(new_params['snippet_id'], text)
              had_error = true
            end
          end
          if had_error
            render json: {
                status: 'ERROR',
                message: '1+ notes not saved',
                data: []
            }, status: :unprocessable_entity
          else
            render json: { status: 'SUCCESS', message: 'Saved notes', data: [] }, status: :ok
          end
        end
      end

      def destroy
        note = Note.find(params[:id])
        note.destroy
        render json: {status: 'SUCCESS', message: 'Deleted note', data: note}, status: :ok
      end

      private

      def note_params
        params.permit(:snippet_id, notes: [])
      end

      def create_single_note(snippet_id, text)
        new_note = {
          snippet_id: snippet_id,
          text: text
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


