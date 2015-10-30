class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = Note.all
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
  end

  def update
    @note.assign_attributes(note_params)
    if @note.valid?
      resource = Resources::Note.new(@note.user_id, @note.text, @note.uuid)
      Commands::UpdateNote.execute(resource)
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:text, :uuid)
  end
end
