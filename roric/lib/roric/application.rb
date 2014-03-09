require 'pry'
class Roric::Application
  include Celluloid::Logger

  attr_reader :supervisor

  class << self
    def start!
      new.start!
    end
  end

  def initialize
    @servers = Roric::Server.subclasses
  end

  def start!
    @servers.each do |server|
      supervisor.supervise_as server.config[:name], server, true, supervisor
    end

    self
  end

  def supervisor
    Celluloid::Actor[:roric_application_supervisor] ||= Celluloid::SupervisionGroup.run!
  end

  def sleep_until_terminated
    Celluloid::Actor.join(supervisor)
  end
end
