class Roric::Server
  include Celluloid
  include Celluloid::IO
  include Celluloid::Logger

  finalizer :cleanup

  attr_reader :config

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

  def initialize autostart = false
    @config = self.class.config
    return unless valid_config?

    async.start! if autostart
  end

  def start!
    info "Starting up #{@config[:name]} server.."
    @socket = TCPSocket.new(@config[:host], @config[:port])

    register

    info "Processing messages now."
    process_messages
  end


  def write_msg msg
    @socket.write(msg + "\r\n")
  end

  private


  def register
    info "Sending registration information"
    @socket.write "NICK " + @config[:nick] + "\r\n"
    @socket.write "USER roricbot 0 * :A Roric IRC Bot\r\n"
  end

  def process_messages
    begin
      while line = @socket.gets.chomp
        puts line

        if line =~ /roricquit/
          break
        end

        if line =~ /roricraise/
          raise Exception, "test exception"
        end
      end
      @socket.write("QUIT :Quitting\r\n")
      terminate
      signal "quit", ""
    rescue Exception => e
      error "Error in read loop: #{e.message}."
      # After logging, re-raise to restart the actor if supervised.
      raise Exception
    ensure
      @socket.close
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
