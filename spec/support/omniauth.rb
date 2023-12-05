# spec/support/omniauth.rb

def generate_valid_auth_hash(email, name, password)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123456',
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
  
def generate_invalid_auth_hash(email, name, password)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123456',
      'info' => {
        'email' => nil,
        'name' => name
      },
      'extra' => {
        'raw_info' => {
          'node_id' => password
        }
      }
    })
end

def generate_valid_google_auth_hash(email, name, password)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      'provider' => 'google_oauth2',
      'uid' => '123456',
      'info' => {
        'email' => email,
        'name' => name
      },
      'credentials' => {
        'token' => password
      }
    })
end
  