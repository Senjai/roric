require "socket"

class Roric::Server
  attr_reader :host, :port

  def initialize(conn_config)
    @host = conn_config[:host]
    @port = conn_config[:port]
  end

  def start!
    @socket = TCPSocket.new @host, @port

    run_connect_hooks

    while line = @socket.gets("\r\n")
      puts line
    end
  ensure
    @socket.close
  end

  def run_connect_hooks
    # Template Method
  end
end
