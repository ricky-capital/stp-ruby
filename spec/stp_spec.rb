require 'spec_helper'

RSpec.describe Stp do
  it 'has a version number' do
    expect(Stp::VERSION).not_to be nil
  end

  it 'allows subscribing to events with an object that responds to call' do
    abono = Stp::Abono.new(File.read('spec/fixtures/send_abono.xml'))
    subscriber = double("sbuscriber")
    Stp.subscribe('abono', subscriber)

    expect(subscriber).to receive(:call)

    Stp.instrument('abono', resource: abono)
  end
end
