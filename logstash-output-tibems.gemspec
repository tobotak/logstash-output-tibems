Gem::Specification.new do |s|
  s.name          = 'logstash-output-tibems'
  s.version       = '1.0.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Send events to EMS queue'
  s.description   = 'This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program'
  s.homepage      = 'https://github.com/tobotak/logstash-output-tibems'
  s.authors       = ['tobotak for ailleron']
  s.email         = 'karol.tobota@ailleron.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
  s.files << 'lib/jms-2.0.jar'
  s.files << 'lib/tibcrypt.jar'
  s.files << 'lib/tibjms.jar'
  s.files << 'lib/tibjmsadmin.jar'
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_development_dependency "logstash-devutils"
end
