def get_url(path)
  raise %(Please set an 'endpoint' environment variable provided with the url of the api) unless ENV.key?('endpoint')
  url = ENV['endpoint']
  url = "#{url}/" unless url.end_with?('/')
  url = "#{url}#{@urlbasepath}/" unless @urlbasepath.to_s.empty?
  url = "#{url}#{path}" unless path.empty?
  url
end
