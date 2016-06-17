class MoveInformationController < ApplicationController
  def show
    form = Forms::MoveInformation.new(move).tap(&:prepopulate!)
    view_context = FormModelPair.new(form, escort)

    render_cell :move_information, view_context
  end

  def add_destination
    form = Forms::MoveInformation.new(move)
    form.deserialize(params[:move_information])
    form.add_destination
    view_context = FormModelPair.new(form, escort)

    render_cell :move_information, view_context
  end

  def update
    form = Forms::MoveInformation.new(move)

    if form.validate(params[:move_information])
      form.save
      redirect_to profile_path(escort)
    else
      form.prepopulate!
      view_context = FormModelPair.new(form, escort)
      render_cell :move_information, view_context
    end
  end

  private

  def move
    @move ||= (escort.move || escort.build_move)
  end

  FormModelPair = Struct.new(:form, :escort)
end
