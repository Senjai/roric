class Roric::Server
  include Celluloid
  include Celluloid::Logger

  finalizer :cleanup

  attr_reader :config, :connection

  # Server configuration methods
  class << self
    # TODO: Too much typing for repetitive things.
    # get a computer to do the below.
    #
    # Also, do this better..
    def inherited klass
      @classes ||= []
      @classes << klass
    end

    def name name
      @name = name
    end

    def host host
      @host = host
    end

    def port port
      @port = port
    end

    def nick nick
      @nick = nick
    end

    def config
      {
        nick: @nick,
        port: @port,
        host: @host,
        name: @name
      }
    end

    def subclasses
      @classes
    end
  end

  def initialize autostart = false, supervisor = nil, connection = Connection
    @config = self.class.config
    return unless valid_config?
    @supervisor = supervisor
    @connection_class = connection

    async.start! if autostart
  end

  def start!
    info "Starting up #{@config[:name]} server.."
    @connection = @connection_class.new(@config[:host], @config[:port])

    register

    info "Processing messages now."
    process_messages
  end

  class Connection
    include Celluloid
    include Celluloid::IO

    attr_reader :host, :port

    def initialize host, port
      @host = host
      @port = port
      @socket = TCPSocket.new(host, port)
      self
    end

    def write(string)
      @socket.write(string + "\r\n")
    end

    def gets
      @socket.gets
    end

    def close
      @socket.close
    end
  end

  private

  def register
    info "Sending registration information"
    @connection.write "NICK " + @config[:nick]
    @connection.write "USER roricbot 0 * :A Roric IRC Bot"
  end

  def process_messages
    begin
      while line = @connection.gets.chomp
        puts line

        if line =~ /roricquit/
          break
        end

        if line =~ /roricraise/
          raise Exception, "test exception"
        end
      end
      @connection.write("QUIT :Quitting")
      @supervisor.async.terminate if @supervisor
    rescue Exception => e
      error "Error in read loop: #{e.message}."
      # Re raise after logging
      raise e
    ensure
      @connection.close
    end
  end

  def cleanup
  end

  def valid_config?
    errors = []
    required_args = [:port, :host, :nick, :name]
    required_args.each do |arg|
      errors << "#{arg} is not present" if @config[arg].nil?
    end

    if errors.any?
      errors = errors.join(", ")
      error "Config validation failed with #{errors}"
      return false
    end

    true
  end
end
