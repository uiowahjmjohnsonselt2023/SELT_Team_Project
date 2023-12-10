# features/support/omniauth.rb

OmniAuth.config.test_mode = true

Before do
  OmniAuth.config.mock_auth[:github] = nil
  OmniAuth.config.mock_auth[:google_oauth2] = nil
end

def mock_github_auth_hash(email, name, uid = '123456', password = 'valid_password')
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
    'provider' => 'github',
    'uid' => uid,
    'info' => {
      'email' => email,
      'name' => name
    },
    'extra' => {
      'raw_info' => {
        'node_id' => password
      }
    }
  })
end

def mock_google_auth_hash(email, name, uid = '123456', token = 'valid_token')
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    'provider' => 'google_oauth2',
    'uid' => uid,
    'info' => {
      'email' => email,
      'name' => name
    },
    'credentials' => {
      'token' => token
    }
  })
end
