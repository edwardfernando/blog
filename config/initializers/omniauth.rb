OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '653128454709649', '8d2781918919f88e36a4461705011eb7', :scope => 'email', :display => 'page'
end