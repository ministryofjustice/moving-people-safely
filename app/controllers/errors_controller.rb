# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def not_found
    render :show, status: :not_found
  end

  def unprocessable_entity
    render :show, status: :unprocessable_entity
  end

  def internal_server_error
    render :show, status: :internal_server_error
  end
end
