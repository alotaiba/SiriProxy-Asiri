# encoding=utf-8
require 'cora'
require 'siri_objects'
require 'siriproxy-asiri/siriproxy-asiri'

class SiriProxy::Plugin::Asiri < SiriProxy::Plugin
  include SiriproxyAsiri
  
  attr_accessor :language
  
  def initialize(config)
    self.language = config['language']
    require_name = File.expand_path("~/.siriproxy/languages/#{self.language}")
    require require_name
  end
  
  filter "StartSpeechRequest", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object)
  end
  
  filter "SpeechPacket", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object)
  end
  
  filter "SpeechFailure", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object)
  end
  
  filter "FinishSpeech", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object, :language => self.language)
  end
  
  filter "SpeechRecognized", direction: :from_guzzoni do |object|
    result = SiriproxyAsiri.filter(object)
    object["properties"]["recognition"]["properties"]["phrases"] = result
  end
end
