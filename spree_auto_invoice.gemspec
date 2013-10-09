# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auto_invoice'
  s.version     = '2.0.4'
  s.summary     = 'A spree auto invoice generator with state machine'
  s.description = 'Invoice generator for spree that generate invoice automatically on order paid'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Geekcups srls'
  s.email     = 'info@geekcups.com'
  s.homepage  = 'http://www.geekcups.com'
  

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1.1'
  s.add_dependency 'wicked_pdf'
  s.add_dependency 'rubyzip'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
