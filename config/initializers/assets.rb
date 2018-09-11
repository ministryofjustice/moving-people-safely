# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('node_modules/govuk-frontend')
Rails.application.config.assets.paths << Rails.root.join('node_modules/govuk-frontend/assets')
Rails.application.config.assets.paths << Rails.root.join('node_modules/govuk-frontend/assets/images')
Rails.application.config.assets.paths << Rails.root.join('node_modules/govuk-frontend/assets/fonts')
Rails.application.config.assets.paths << Rails.root.join('node_modules/html5shiv/dist')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
    gov.uk_logotype_crown.png
    main-ie8
    main
    nomis_alerts
    print
    accessible-autocomplete.min.css
    auto-complete.js
    flowplayer.js
    flowplayer-3.2.13.min.js
    govuk-template*.css
    fonts*.css
    govuk-template.js
    ie.js
    apple-touch-icon-180x180.png
    apple-touch-icon-167x167.png
    apple-touch-icon-152x152.png
    apple-touch-icon.png
    gov.uk_logotype_crown_invert.png
    gov.uk_logotype_crown_invert_trans.png
    gov.uk_logotype_crown.svg
    opengraph-image.png

    moj_crest.png
    govuk-logotype-crown.png
    application_ie8.css
    html5shiv.js
    all.js
)
