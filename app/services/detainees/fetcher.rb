module Detainees
  class Fetcher
    def initialize(prison_number, options = {})
      @prison_number = prison_number.upcase
      @options = options
      @errors = []
    end

    def call
      fetch_details if fetch_details?
      fetch_image if fetch_image? && !has_detainee_not_found_error?
      Response.new(remote_attrs, errors)
    end

    class Response
      attr_reader :errors

      def initialize(attrs, errors = [])
        @attrs = attrs
        @errors = errors
      end

      def error?
        !errors.empty?
      end

      def to_h
        attrs
      end

      private

      attr_reader :attrs
    end

    private

    attr_reader :prison_number, :options, :errors, :details_attrs, :image_attrs

    def pull_data
      options.fetch(:pull, :all).to_sym
    end

    def fetch_details?
      pull_data == :all || pull_data == :details
    end

    def fetch_image?
      pull_data == :all || pull_data == :image
    end

    def details_attrs
      @details_attrs ||= {}
    end

    def image_attrs
      @image_attrs ||= {}
    end

    def remote_attrs
      details_attrs.merge(image_attrs)
    end

    def fetch_details
      response = DetailsFetcher.new(prison_number).call

      if response.error
        @details_attrs = {}
        @errors << error_message_for(:details, response.error)
      else
        @details_attrs = response.to_h
      end
    end

    def fetch_image
      response = ImageFetcher.new(prison_number).call

      if response.error
        @image_attrs = {}
        @errors << error_message_for(:image, response.error)
      else
        @image_attrs = response.to_h
      end
    end

    def error_message_for(resource, error)
      case error
      when 'api_error', 'internal_error'
        "#{resource}.unavailable"
      when 'not_found'
        "#{resource}.not_found"
      when 'invalid_input'
        "#{resource}.invalid_input"
      end
    end

    def has_detainee_not_found_error?
      return false if errors.empty?
      errors.include?('details.not_found')
    end
  end
end
