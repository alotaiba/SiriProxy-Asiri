# encoding=utf-8
require 'cora'
require 'siri_objects'
require 'siriproxy-asiri/siriproxy-asiri'

class SiriProxy::Plugin::Asiri < SiriProxy::Plugin
  include SiriproxyAsiri
  
  attr_accessor :audio_tmp_path, :language
  
  def initialize(config)
    self.language = config['language']
  end
  
  filter "StartSpeechRequest", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object)
  end
  
  filter "SpeechPacket", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object)
  end
  
  #Also check for SpeechFailure
  filter "FinishSpeech", direction: :from_iphone do |object|
    result = SiriproxyAsiri.filter(object, :language => self.language)
  end
  
  filter "SpeechRecognized", direction: :from_guzzoni do |object|
    result = SiriproxyAsiri.filter(object)
    object["properties"]["recognition"]["properties"]["phrases"] = result
  end
  
  listen_for /عليكم/i do
    say "وعليكم السلام", spoken: "Walikum Alsalam"
    
    request_completed
  end
  
  listen_for /مرحبا/i do
    say "أهلين", spoken: "Ahleen"
    
    request_completed
  end
  
  listen_for /الحال/i do
    say "الحمدلله، وأنت، كيف حالك؟", spoken: "Alhamdulillah, wa ant, keef halek?"
    
    request_completed
  end
  
  listen_for /هل سيربح/i do
    say "يمقن يربح ويمقن لا", spoken: "Yamken Yerbah Wa Yamken La!"
    
    request_completed
  end
end
