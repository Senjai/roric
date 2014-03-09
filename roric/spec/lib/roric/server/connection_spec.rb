require 'spec_helper'

describe Roric::Server::Connection do
  let(:init_args) { ["localhost", 2342] }
  let!(:stringio) { StringIO.new "" }
  subject { described_class.new(*init_args) }

  before do
    allow(Celluloid::IO::TCPSocket).to receive(:new).and_return(stringio)
  end

  context "writing to the connection" do
    before do
      expect(stringio).to receive(:write).with("hello\r\n")
    end

    specify { subject.write("hello") }
  end

  context "reading a line from the connection" do
    let!(:stringio) { StringIO.new "TestLine 1\r\nTest 2\r\n" }

    specify { expect(subject.gets).to eql("TestLine 1\r\n") }
  end

  context "closing the connection" do
    before do
      expect(stringio).to receive(:close)
    end

    specify { subject.close }
  end
end
