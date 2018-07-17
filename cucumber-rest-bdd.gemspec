Gem::Specification.new do |s|
  s.name          = 'cucumber-rest-bdd'
  s.version       = if ENV['TRAVIS'] && ENV['TRAVIS_TAG'] == ''
                      "0.6.1-#{ENV['TAVIS_BUILD_NUMBER']}"
                    else
                      '0.6.1'
                    end
  s.platform      = Gem::Platform::RUBY
  s.date          = '2018-07-09'
  s.summary       = 'BDD Rest API specifics for cucumber'
  s.description   = 'Series of BDD cucumber rules for testing API endpoints'
  s.authors       = ['Graze Developers', 'Harry Bragg', 'Matt Hosking']
  s.email         = [
    'developers@graze.com',
    'harry.bragg@graze.com',
    'Matt.Hosking@alintaenergy.com.au'
  ]
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/graze/cucumber-rest-bdd'
  s.license       = 'MIT'

  s.add_dependency('activesupport', '~> 5.1')
  s.add_dependency('cucumber-api', '~> 0.6')
  s.add_dependency('cucumber-expressions', '~> 5.0', '>= 5.0.17')
  s.add_dependency('easy_diff', '~> 1.0')
end
