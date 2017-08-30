module SignerHelpers
  def configure_signer
    Stp.configure do |config|
      config.key_path = File.expand_path('./spec/support/test-key.pem')
      config.key_passphrase = '12345678'
    end
  end
end
