class Rack::Attack
  # Rate limiting for SMS verification
  throttle('sms_verification_by_ip', limit: 5, period: 1.hour) do |req|
    if req.path == '/sms_verification/request' && req.get?
      req.ip
    end
  end

  # Rate limiting for verification code submission
  throttle('verification_code_by_ip', limit: 10, period: 1.hour) do |req|
    if req.path == '/sms_verification/verify' && req.post?
      req.ip
    end
  end

  # Rate limiting for user registration
  throttle('registration_by_ip', limit: 3, period: 1.hour) do |req|
    if req.path == '/users' && req.post?
      req.ip
    end
  end

  # Block suspicious requests
  blocklist('blocklist') do |req|
    # Block requests with suspicious user agents
    suspicious_agents = [
      /bot/i,
      /crawler/i,
      /spider/i,
      /scraper/i
    ]
    
    suspicious_agents.any? { |pattern| req.user_agent&.match?(pattern) }
  end

  # Custom response for blocked requests
  self.blocklisted_response = lambda do |env|
    [429, {'Content-Type' => 'application/json'}, ['{"error": "Too many requests"}']]
  end

  # Custom response for throttled requests
  self.throttled_response = lambda do |env|
    [429, {'Content-Type' => 'application/json'}, ['{"error": "Rate limit exceeded"}']]
  end
end 