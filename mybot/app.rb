require 'rubygems'
require 'bundler/setup'

require 'roric'

class MyServer < Roric::Server
  def run_connect_hooks
    puts "writing stuff"
    @socket.write "NICK rorictestbot" + Roric::LINEBREAK
    @socket.write "USER roric 0 * :A Roric Bot" + Roric::LINEBREAK
    @socket.write "JOIN #sentest" + Roric::LINEBREAK
  end
end
server = MyServer.new(host: "irc.freenode.net", port: 6667)
server.start!

