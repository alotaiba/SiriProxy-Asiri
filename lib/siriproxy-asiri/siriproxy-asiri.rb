require 'uri'
require 'curb'
require 'json'
require 'uuidtools'

module SiriproxyAsiri
  BASE_URL = "https://www.google.com/speech-api/v1/recognize"
  DEFAULT_OPTIONS = {
      :language => "ar-EG"
    }
  class << self
    attr_accessor :tmp_path, :recognized_speech
    def filter(object, opts={})
      #We don't need the direction, since these packets come from either Guzzoni or iPhone (one way)
      case object["class"]
      when "StartSpeechRequest"   then self.tmp_path = File.join(File.dirname(__FILE__), '..', '..', 'tmp', UUIDTools::UUID.random_create.to_s.upcase)
      when "FinishSpeech"         then self.recognized_speech = parse_speech(opts)
      when "SpeechFailure"        then cleanup #We may need to clean up in CancelRequest as well?
      when "SpeechPacket"         then record_binary(object)
      when "SpeechRecognized"     then inject_speech()
      end
    end
    
    def record_binary(object)
      packetNumber = object["properties"]["packetNumber"]
      packetBinary = object["properties"]["packets"][0]
      
      Dir.mkdir(self.tmp_path) unless File.exists?(self.tmp_path)
      outputFile = File.open(File.join(self.tmp_path, "input-#{packetNumber}.spx"), "w")
      outputFile.write("#{packetBinary}")
      outputFile.close
    end
    
    def decode_audio
      system("speer #{File.join(self.tmp_path)} #{File.join(self.tmp_path)}")
      system("ffmpeg -f s16le -ar 16000 -i #{File.join(self.tmp_path, "output.raw")} -acodec flac -ar 16000 -ab 96k #{File.join(self.tmp_path, "output.flac")} >/dev/null 2>&1")
      #I'm sure there's a better Rubyish way here!
      if File.exist?File.join(self.tmp_path, "output.flac")
        return true
      else
        return false
      end
    end
    
    def request_result(args={})
      arguments = ""
      args.each_with_index { |(key,value),index|
        prefix = index > 0 ? "&" : "?"
        arguments << prefix << URI.escape(key.to_s) << "=" << URI.escape(value.to_s)
      }
      url = BASE_URL + arguments
      
      data = File.read(File.join(self.tmp_path, "output.flac"))
      easy = Curl::Easy.new(url)
      easy.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7"
      easy.headers['Content-Type'] = "audio/x-flac; rate=16000"
      easy.post_body = "Content=#{data}"
      easy.http_post
      
      if easy.response_code == 200
        JSON.parse(easy.body_str)
      else
        false
      end
    end
    
    def inject_speech()
      if self.recognized_speech
        words = self.recognized_speech.split
        phrases = Array.new
        #Put it in a form that Siri interpret can understand
        words.each do |word|
          word_phrase = { "class" => "Phrase",
            "properties" => {
                "interpretations" => [
                  {
                    "class" => "Interpretation",
                    "properties" => {
                      "tokens" => [
                        {
                          "class" => "Token",
                          "properties" => {
                            "removeSpaceBefore" => false,
                            "confidenceScore" => 889.0,
                            "removeSpaceAfter" => false,
                            "endTime" => 740,
                            "text" => word,
                            "startTime" => 0
                            },
                            "group" => "com.apple.ace.speech"
                          }
                        ]
                      },
                      "group" => "com.apple.ace.speech"
                    }
                  ],
                  "lowConfidence" => false
                },
                "group" => "com.apple.ace.speech"
              }
          phrases.push(word_phrase)
        end
      end
      
      phrases
    end
    
    def cleanup
      FileUtils.rm_r File.join(self.tmp_path), :force => true, :secure => true if File.exists?(self.tmp_path)
    end
    
    def parse_speech(opts={})
      options = DEFAULT_OPTIONS.merge opts
      response = false
      if decode_audio
        response = request_result(:lang => options[:language], :maxresult => 4, :client => "chromium")
      end
      cleanup
      #Get the first result
      if response
        response["hypotheses"][0]["utterance"]
      else
        false
      end
    end
  end
end