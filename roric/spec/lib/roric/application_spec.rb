require 'spec_helper'

class AnActor
  include Celluloid
  include Celluloid::Logger

  class << self
    def config
      {name: :test}
    end
  end

  def initialize *args
    info "initialized!"
  end
end

describe Roric::Application do
  describe :start! do
    before do
      allow(Roric::Server).to receive(:subclasses).and_return([AnActor])
      AnActor.any_instance.should_receive(:info).with("initialized!")
      described_class.start!
    end

    specify { Celluloid::Actor[:test].should be }
  end

  describe :[] do
    before do
      expect(Celluloid::Actor).to receive(:[]).with(:thing)
      # Fixes test order dependency
      allow(Celluloid::Actor).to receive(:[]).with(:roric_application_supervisor)
    end

    specify { described_class.start![:thing] }
  end

  describe :sleep_until_terminated do
    let(:instance) { described_class.start! }
    before { expect(Celluloid::Actor).to receive(:join) }

    specify { instance.sleep_until_terminated }
  end
end
