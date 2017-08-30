require 'spec_helper'

RSpec.describe Stp::Configuration do
  context 'when no wsdl is specified' do
    it 'defaults to the demo' do
      expect(Stp.configuration.wsdl).to eq(
        'http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL'
      )
    end
  end

  context 'when a wsdl is specified' do
    it 'is used instead of the deafult' do
      path = '/path/to/wsdl'
      Stp.configure { |config| config.wsdl = path }

      expect(Stp.configuration.wsdl).to eq path
    end
  end

  context "when a private key path is specified" do
    it "is set correctly" do
      path = '/path/to/key'
      Stp.configure { |config| config.key_path = path }

      expect(Stp.configuration.key_path).to eq path
    end
  end

  context "when no private key passphrase is specified" do
    it 'defaults to an empty string' do
      expect(Stp.configuration.key_passphrase).to be_empty
    end
  end

  context "when a private key passphrase is specified" do
    it "is set correctly" do
      passphrase = 'secret'
      Stp.configure { |config| config.key_passphrase = passphrase }

      expect(Stp.configuration.key_passphrase).to eq passphrase
    end
  end
end
