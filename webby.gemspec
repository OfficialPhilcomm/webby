Gem::Specification.new do |s|
  s.name = 'webby'
  s.version = '1.0.2'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.1.0"
  s.summary = 'Static webserver'
  s.description = "Static webserver to quickly host files in a folder"
  s.authors = ['Philipp Schlesinger']
  s.email = ['info@philcomm.dev']
  s.homepage = 'http://github.com/officialphilcomm/webby'
  s.license = 'MIT'
  s.files = Dir.glob('{lib,bin}/**/*')
  s.require_path = 'lib'
  s.executables = ['webby']

  s.metadata = {
    "documentation_uri" => "https://github.com/OfficialPhilcomm/webby",
    "source_code_uri"   => "https://github.com/OfficialPhilcomm/webby",
    "changelog_uri"     => "https://github.com/OfficialPhilcomm/webby/blob/master/changelog.md"
  }

  s.add_dependency "rack", ["2.2.10"]
  s.add_dependency "thin", ["1.8.2"]
  s.add_dependency "tty-option", ["~> 0.2"]
  s.add_dependency "pastel", ["~> 0.8.0"]
end
