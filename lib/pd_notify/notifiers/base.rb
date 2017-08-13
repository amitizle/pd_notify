
module PdNotify
  module Notifiers
    class Base
      def initialize(opts = {})
        @opts = opts
      end

      def notify(incidents)
        raise NotImplementedError, "#{self.class.name}#notify is not implemented"
      end
    end
  end
end
