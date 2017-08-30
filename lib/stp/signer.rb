module Stp
  class Signer
    def initialize
      raise 'Configuration error' if Stp.configuration.key_path.nil?

      @pkey = OpenSSL::PKey::RSA.new(
        File.read(Stp.configuration.key_path),
        Stp.configuration.key_passphrase
      )
    end

    def sign(message)
      Base64.encode64(@pkey.sign(OpenSSL::Digest::SHA256.new, message))
        .tr("\n", '')
    end
  end
end
