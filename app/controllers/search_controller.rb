# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authorize_prison_officer!, only: :show

  def new
    @form = Forms::Search.new
    render :show
  end

  def show
    @form = Forms::Search.new(search_params)

    if @form.valid?
      find_same_prisoner_escort
    else
      flash.now[:error] =
        t('alerts.search.invalid_identifier', type: @form.identifier_type, identifier: @form.identifier)
    end
  end

  private

  def search_params
    params.require(:search).permit(:prison_number, :pnc_number)
  end

  def find_same_prisoner_escort
    @escort = Escort.uncancelled
    @escort = @escort.from_prison.find_by(prison_number: @form.prison_number) if @form.prison_number
    @escort = @escort.from_police.find_by(pnc_number: Detainee.standardise_pnc(@form.pnc_number)) if @form.pnc_number
  end

  def prison_number
    search_params[:prison_number]
  end
end
