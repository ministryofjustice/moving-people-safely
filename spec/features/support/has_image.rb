module Capybara
  class Session
    def has_image?(options)
      raise ArgumentError, 'At least :src or :alt has to be provided' unless options[:src] || options[:alt]
      criterias = []
      criterias << "[contains(@src, '#{options[:src]}')]" if options[:src]
      criterias << "[@alt='#{options[:alt]}']" if options[:alt]
      has_xpath?("//img#{criterias.join('')}")
    end
  end
end
