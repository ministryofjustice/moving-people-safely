class MovesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_move_already_exists, only: %i[new create]
  helper_method :escort, :move

  def new
    form = Forms::Move.new(escort.build_move)
    form.prepopulate!
    render locals: { form: form }
  end

  def create
    form = Forms::Move.new(escort.build_move)
    add_destination(form, template: :new)
    return if performed?

    if form.validate(params[:move])
      form.save
      redirect_to escort_path(escort)
    else
      render :new, locals: { form: form }
    end
  end

  def edit
    form = Forms::Move.new(move)
    form.prepopulate!
    render locals: { form: form }
  end

  def update
    form = Forms::Move.new(move)
    add_destination(form, template: :edit)
    return if performed?

    if form.validate(params[:move])
      form.save
      redirect_to escort_path(escort)
    else
      render :edit, locals: { form: form }
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def move
    escort.move || raise(ActiveRecord::RecordNotFound)
  end

  def add_destination(form, options)
    if params.key? 'move_add_destination'
      form.deserialize params[:move]
      form.add_destination
      render options.fetch(:template), locals: { form: form }
    end
  end

  def redirect_if_move_already_exists
    redirect_to escort_path(escort), alert: t('alerts.escort.move.exists') if escort.move
  end
end
