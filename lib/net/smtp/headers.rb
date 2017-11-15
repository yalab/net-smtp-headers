require 'net/smtp'
require "net/smtp/headers/version"

module Net
  class SMTP
    def self.set_debug_output=(io)
      @debug_output = io
    end

    module Headers
      def get_response(reqline)
        debug_output.write reqline if debug_output
        super
      end

      def recv_response
        res = super
        debug_output.write res.instance_variable_get(:@string) if debug_output
        res
      end

      private
      def debug_output
        @debug_output || self.class.instance_variable_get(:@debug_output)
      end
    end
  end
end

Net::SMTP.send(:prepend, Net::SMTP::Headers)
