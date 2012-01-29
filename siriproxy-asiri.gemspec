# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'siriproxy-asiri/version'

Gem::Specification.new do |s|
  s.name        = "siriproxy-asiri"
  s.version     = SiriproxyAsiri::VERSION
  s.authors     = ["alotaiba"]
  s.email       = ["@alotaiba"]
  s.homepage    = ""
  s.summary     = %q{Multilingual Siri Proxy Plugin}
  s.description = %q{Let Siri speak your language with Asiri. Thanks to Google speech recognition service, Asiri can be configured to speak any language that is supported by Google. }

  # s.rubyforge_project = "siriproxy-asiri"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.requirements << 'speer - a native c application to convert speex to raw) https://github.com/alotaiba/speer'
  s.requirements << 'ffmpeg - a complete, cross-platform solution to record, convert and stream audio and video http://ffmpeg.org/'
  
  s.add_runtime_dependency "curb"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "uuidtools"
end
