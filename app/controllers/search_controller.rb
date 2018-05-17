class SearchController < ApplicationController
  before_action :validate_search
  before_action :authorize_user_to_access_prisoner!, if: :valid_search?

  def index
    render :index, locals: {
      search_form: search_form,
      prison_number: params[:prison_number]
    }
  end

  private

  def search_form
    @_search_form ||= Forms::Search.new
  end

  def validate_search
    search_form.validate(search_params) if search_params.present?
  end

  def search_params
    params.permit(:prison_number).delete_if { |_key, value| value.blank? }
  end

  def valid_search?
    search_params.present? && search_form.valid?
  end

  def prison_number
    search_form.prison_number
  end
end
