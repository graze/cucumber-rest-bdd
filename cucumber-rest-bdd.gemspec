Gem::Specification.new do |s|
  s.name          = 'cucumber-rest-bdd'
  s.version       = '0.6.0'
  s.version       = "#{s.version}-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS'] && ENV['TRAVIS_TAG'] == ''
  s.platform      = Gem::Platform::RUBY
  s.date          = '2018-07-09'
  s.summary       = 'BDD Rest API specifics for cucumber'
  s.description   = 'Series of BDD cucumber rules for testing API endpoints'
  s.authors       = ["Harry Bragg", "Matt Hosking"]
  s.email         = ["harry.bragg@graze.com", "Matt.Hosking@alintaenergy.com.au"]
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
  s.homepage      = 'https://github.com/graze/cucumber-rest-bdd'
  s.license       = 'MIT'

  s.add_dependency('cucumber-api', '~> 0.6')
  s.add_dependency('cucumber-expressions', '~> 5.0', '>= 5.0.17')
  s.add_dependency('activesupport', '~> 5.1')
  s.add_dependency('easy_diff', '~> 1.0')
end
