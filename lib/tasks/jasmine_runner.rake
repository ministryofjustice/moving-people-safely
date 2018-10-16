# frozen_string_literal: true

task(:default).prerequisites << task('jasmine:ci') if %w[development test].include? Rails.env
