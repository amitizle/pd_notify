require 'pd_notify/notifiers/base'
require 'terminal-notifier'

module PdNotify
  module Notifiers
    class Mac < Notifiers::Base

      def initialize(opts = {})
        config_instance = PdNotify::Utils::Config.instance
        @app_icon_url = config_instance.get('app_icon_url') || config_instance.default('app_icon_url')
        super(opts)
      end
      # Waiting for https://github.com/julienXX/terminal-notifier/pull/182
      # to be merged, then we'll be able to use
      #   actions: 'Ack, Resolve', reply: true
      # etc.
      def notify(incidents)
        incidents.each do |incident|
          title = incident['title']
          description = incident['description']
          created_at = incident['created_at']
          urgency = incident['urgency']
          url = incident['html_url']
          # Since when TerminalNotifier#notify is called
          # with an `open` option it's blocking, we'll do those
          # in threads :/
          Thread.new do
            ::TerminalNotifier.notify(
              title,
              title: description,
              subtitle: "Urgency: #{urgency}, Created at: #{created_at}",
              open: url,
              sound: 'default',
              group: 'pagerduty',
              appIcon: @app_icon_url
            )
          end
        end
      end
    end
  end
end
