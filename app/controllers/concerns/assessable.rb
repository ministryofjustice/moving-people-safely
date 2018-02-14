module Assessable
  extend ActiveSupport::Concern

  included do
    include Wicked::Wizard
    include Wizardable

    def add_multiples
      add_multiple_action = params.permit!.to_h.keys.find { |k| k =~ /add_multiple/ }

      return unless add_multiple_action
      /add_multiple_(?<multiple_attribute>.*)$/ =~ add_multiple_action
      form.add_multiple(multiple_attribute)
      view = params[:action] == 'create' ? :new : :edit
      render view, locals: { form: form }
    end
  end
end
