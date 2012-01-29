# encoding=utf-8

#######
# This is a "hello world" style language implementation.
# It takes the same functions as a normal SiriProxy plugin.
# This is written in Arabic
# 
# Remember to copy the folder 'languages' into your ~/.siriproxy/ folder
######

class SiriProxy::Plugin::Asiri < SiriProxy::Plugin
  
  listen_for /عليكم/ do
    say "وعليكم السلام", spoken: "Walikum Alsalam"
  
    request_completed
  end

  listen_for /مرحبا/ do
    say "أهلين", spoken: "Ahleen"
  
    request_completed
  end

  listen_for /الحال/ do
    say "الحمدلله، وأنت، كيف حالك؟", spoken: "Alhamdulillah, wa ant, keef halek?"
  
    request_completed
  end

  listen_for /هل سيربح/ do
    say "يمقن يربح ويمقن لا", spoken: "Yamken Yerbah Wa Yamken La!"
  
    request_completed
  end
  
end