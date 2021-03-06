require 'rubygems'
require 'bundler/setup'

require 'roric'
require 'pry'

class Freenode < Roric::Server
  name :freenode
  host "irc.freenode.net"
  port 6667
  nick "RoricTest2"
end

app = Roric::Application.start!

# Give it enough time to connect before issuing commands.
sleep 10

freenode = app[:freenode]
freenode.connection.write "JOIN #sentest"
freenode.connection.write "PRIVMSG #sentest :Hello World!"

app.sleep_until_terminated
