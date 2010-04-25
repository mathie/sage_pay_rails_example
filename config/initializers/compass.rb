# Require any additional compass plugins here.

Compass.configuration.project_type          = :rails
Compass.configuration.project_path          = RAILS_ROOT
Compass.configuration.http_path             = "/"
Compass.configuration.sass_dir              = "app/stylesheets"
Compass.configuration.css_dir               = "public/stylesheets"
Compass.configuration.images_dir            = "public/images"
Compass.configuration.javascripts_dir       = "public/javascripts"
Compass.configuration.http_images_path      = "/images"
Compass.configuration.http_stylesheets_path = "/stylesheets"
Compass.configuration.http_javascripts_path = "/javascripts"

# To enable relative paths to assets via compass helper functions. Uncomment:
# Compass.configuration.relative_assets     = true

Compass.configuration.environment = RAILS_ENV.to_sym
Compass.configure_sass_plugin!
