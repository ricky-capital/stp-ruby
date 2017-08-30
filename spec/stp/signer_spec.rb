require 'spec_helper'
require 'support/signer_helpers'

RSpec.configure do |c|
  c.include SignerHelpers
end

RSpec.describe Stp::Signer do
  context 'when the private key path has not been specified' do
    it 'raises a configuration exception' do
      expect { Stp::Signer.new }.to raise_error('Configuration error')
    end
  end

  context 'when given an incorrect private key path' do
    it 'raises a file not found exception' do
      Stp.configure { |config| config.key_path = '/incorrect/path' }

      expect { Stp::Signer.new }.to raise_error(Errno::ENOENT)
    end
  end

  context 'when given an incorrect passphrase' do
    it 'raises an PKey exception' do
      Stp.configure do |config|
        config.key_path = File.expand_path('./spec/support/test-key.pem')
      end

      expect { Stp::Signer.new }.to raise_error(OpenSSL::PKey::RSAError)
    end
  end

  context 'when given a correct private key path and passphrase' do
    it 'creates the signer correctly' do
      configure_signer

      expect(Stp::Signer.new).not_to be_nil
    end
  end

  context 'when configured correctly and given a message' do
    it 'signs the message correctly' do
      configure_signer

      expect(Stp::Signer.new.sign('test')).to eq(
        'QX33IYzsfdd0zOB9dD+hhDa9xhp37HTwsRdGiZQRmVp/woA9s0eCSzjFdBhlU5gQ3QHgcpxV+hccaCaq7+fcyliC/caRH040pzkxYVk+BdqQfGRhyUG9m0GrjHMmfn6r5I+WdpmjA5587+F7OexBVqH7hXaQQxnaTN6V7pmCnuI='
      )
    end
  end

  after :each do
    Stp.reset
  end
end
