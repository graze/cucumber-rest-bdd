def get_url(path)
    raise %/Please set an 'endpoint' environment variable provided with the url of the api/ if !ENV.has_key?('endpoint')
    url = %/#{ENV['endpoint']}#{path}/
end
