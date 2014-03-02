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

puts "Subclasses: #{Roric::Server.subclasses}"

# Create a bot and supervise it.
Freenode.supervise_as :freenode, args: [true]

# Give it enough time to connect before issuing commands.
sleep 10

freenode = Celluloid::Actor[:freenode]
freenode.write_msg "JOIN #sentest"
freenode.write_msg "PRIVMSG #sentest :Hello World!"

# Wait for the bot to exit gracefully (i.e. not with a crash)
while Celluloid::Actor.join(Celluloid::Actor[:freenode])
  # If it crashed, it should have been restarted, check for this.
  puts "Checking for supervisor restart."
  sleep 5
  break unless Celluloid::Actor[:freenode]
end
