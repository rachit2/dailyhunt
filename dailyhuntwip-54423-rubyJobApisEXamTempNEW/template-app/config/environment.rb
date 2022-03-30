# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.config.assets.precompile += %w(epub.js import_data.js content.js content_video.js content_text.js tinymce_custom.js content.scss rails_admin/custom/ui.js rails_admin/custom/theming.scss) 
