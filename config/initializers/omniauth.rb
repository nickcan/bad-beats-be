Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FBB_FACEBOOK_ID"], ENV["FBB_FACEBOOK_SECRET"]
end
