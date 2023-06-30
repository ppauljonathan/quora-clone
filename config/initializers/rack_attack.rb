# need to enable dev:cache for this to work
LIMIT = 100
PERIOD = 1.hour
PUBLIC_API_REGEX = %r{^/api/topics/+}

Rack::Attack.throttle('reqests to api', limit: LIMIT, period: PERIOD) do |req|
  req.ip if req.path =~ PUBLIC_API_REGEX
end
