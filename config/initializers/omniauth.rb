OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '472154496257451', 'f89aa9fdb8be8dde5c02a0383b82e5fb' ,{:scope => 'user_photos,email'}
  
end   