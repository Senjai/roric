require 'rubygems'
require 'bundler/setup'

require 'roric'

class MyBot < Roric::IRCBot
  server "irc.freenode.net"
  port "6667"

  channels "sentest"

  on "channel:join", "Hello World!"
end
