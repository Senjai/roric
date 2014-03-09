require 'spec_helper'

describe Roric::Server do
  before do
    class AClass < Roric::Server
      name :something
      host "ahost.com"
      port 5345
      nick "RoricBot"
    end
  end

  subject { AClass.new }

  it "lists AClass as a subclass" do
    expect(described_class.subclasses).to include(AClass)
  end

  context "configuration" do
    it "should be returned in the configuration hash" do
      hash = {
        name: :something,
        host: "ahost.com",
        port: 5345,
        nick: "RoricBot"
      }

      expect(AClass.config).to eql(hash)
    end

    context "that is invalid" do
      before do
        AClass.name nil
        AClass.any_instance.should_receive(:error).with("Config validation failed with name is not present")
      end

      specify { AClass.new }
    end
  end

  describe :start do
    before do
      allow(Roric::Server::Connection).to receive(:new).and_return(stringio)
      expect(stringio).to receive(:write).with("NICK RoricBot")
      expect(stringio).to receive(:write).with("USER roricbot 0 * :A Roric IRC Bot")
    end

    context "the basics" do
      before { expect(stringio).to receive(:write).with("QUIT :Quitting") }
      let!(:stringio) { StringIO.new "roricquit" }

      specify { AClass.new.start! }
    end

    context "raising an exception" do
      let!(:stringio) { StringIO.new "roricraise" }
      let!(:aclass) { AClass.new }

      specify { expect{aclass.start!}.to raise_error }
    end
  end
end
