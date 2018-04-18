require File.join(File.dirname(__FILE__), *%w(lib iggy version))

Gem::Specification.new do |s|
  s.name        = "iggy"
  s.version     = Iggy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Ray"]
  s.email       = ["matt@chef.io"]
  s.license     = 'Apache-2.0'
  s.homepage    = "https://github.com/mattray/iggy"
  s.summary     = %q{Generate InSpec compliance profiles from Terraform.}
  s.description = %q{Generate InSpec compliance profiles from Terraform by tagging instances and mapping Terraform to InSpec.}
  s.required_ruby_version = '>= 2.4'

  s.files         = Dir['LICENSE', 'README.md', 'bin/*', 'lib/**/*']
  s.test_files    = Dir.glob('test/**/*')
  s.executables   = Dir.glob('bin/**/*').map{ |f| File.basename(f) }
  s.require_path  = "lib"

  s.add_dependency('mixlib-cli', '~> 1.7')
  s.add_development_dependency('rspec', '~> 3')
  s.add_development_dependency('rake', '~> 12')
  s.add_development_dependency('chefstyle', '~> 0.5')
end
