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
    Celluloid::Actor[:roric_application_supervisor] = Celluloid::SupervisionGroup.run!
    freenode = @servers.first
    Celluloid::Actor[:roric_application_supervisor].supervise_as freenode.config[:name], Freenode, args: [true]
  end
end
