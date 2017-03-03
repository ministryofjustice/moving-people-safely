module LocalizerHelpers
  def localize_key(key, value, options = {})
    locale = options.fetch(:locale, :en)
    hash = key.split('.').reverse.inject(value) { |a, n| { n => a } }
    I18n.backend.store_translations(locale, hash)
  end
end
