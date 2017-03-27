# frozen_string_literal: true
RailsAdmin.config do |config|
  # REQUIRED:
  # Include the import action
  # See https://github.com/sferik/rails_admin/wiki/Actions
  config.actions do
    all
    import
  end

  # Optional:
  # Configure global RailsAdminImport options
  config.configure_with(:import) do |con|
    con.logging = true
  end

  # Optional:
  # Configure model-specific options using standard RailsAdmin DSL
  # See https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL
  config.model 'User' do
    import do
      include_all_fields
      exclude_fields :secret_token
    end
  end

  config.model 'Unit' do
    import do
      include_all_fields
    end
  end
end
