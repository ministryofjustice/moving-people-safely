puts '''
A temporary workaround has been put in place to support
Cells with Rails 5. Please check cells/cells-rails for
updates so that the gem can be upgraded and this can be
removed.

The workaround can be found in lib/overrides/cells/testing.rb
'''

require 'cell/testing'

module Cell
  module Testing
    ## Rails 5 no longer supports creating a TestRequest without
    ## providing args to the initializer however we can imitate the
    ## original behaviour using .create

    def controller_for(controller_class)
      return unless controller_class

      controller_class.new.tap do |ctl|
        ctl.request = ::ActionController::TestRequest.create
        ctl.instance_variable_set(
          :@routes,
          ::Rails.application.routes.url_helpers
        )
      end
    end
  end
end
