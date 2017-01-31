class MovesController < ApplicationController
  attr_reader :detainee, :move
  helper_method :detainee, :move
  before_action :find_detainee_data, only: %i[new create]
  before_action :find_move_data, only: %i[edit update]
  before_action :redirect_if_detainee_has_active_move, only: [:new, :create]
  before_action :redirect_unless_move_editable, only: [:edit, :update]

  def new
    form = Forms::Move.new(detainee.moves.build)
    form.prepopulate!
    render locals: { form: form }
  end

  def create
    form = Forms::Move.new(detainee.moves.build)
    add_destination(form, template: :new)
    return if performed?

    if form.validate(params[:move])
      form.save
      redirect_to detainee_path(detainee)
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
      redirect_to detainee_path(detainee)
    else
      render :edit, locals: { form: form }
    end
  end

  private

  def find_detainee_data
    @detainee = Detainee.find(params[:detainee_id])
  end

  def find_move_data
    @move = Move.find(params[:id])
    @detainee = move.detainee
  end

  def add_destination(form, options)
    if params.key? 'move_add_destination'
      form.deserialize params[:move]
      form.add_destination
      render options.fetch(:template), locals: { form: form }
    end
  end

  def redirect_if_detainee_has_active_move
    if detainee.active_move.present?
      redirect_back(fallback_location: root_path(prison_number: detainee.prison_number)) && return
    end
  end

  def redirect_unless_move_editable
    unless AccessPolicy.edit?(move: move)
      redirect_back(fallback_location: root_path)
    end
  end
end
