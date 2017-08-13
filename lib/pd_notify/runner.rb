require 'time'
require 'pd_notify/notifiers/mac'
require 'pd_notify/http_client'

module PdNotify
  class Runner
    def initialize
      config = Utils::Config.instance
      @poll_interval = config.get('poll_interval_seconds') || config.default('poll_interval_seconds')
      @app_icon_url = config.get('app_icon_url') || config.default('app_icon_url')
      @incidents_opts = {
        users: config.get('users') || config.default('users'),
        services: config.get('services') || config.default('services'),
        urgencies: config.get('urgencies') || config.default('urgencies'),
        statuses: config.get('statuses') || config.default('statuses'),
        time_zone: 'UTC'
      }
      @notifiers = [
        PdNotify::Notifiers::Mac.new
      ]
      @http_client = PdNotify::HTTPClient.new
    end

    def run
      trap_signals
      run_loop
    end

    private

    def trap_signals
      ["TERM", "INT"].each do |sig|
        Signal.trap(sig) do
          puts "Bye-bye"
          exit 0
        end
      end
    end

    def run_loop
      last_check_time = Time.now.utc.iso8601
      loop do
        response = API::V2::Incidents.list(@http_client, @incidents_opts.merge({since: last_check_time}))
        incidents = response['incidents']
        last_check_time = Time.now.utc.iso8601
        if !incidents.empty?
          @notifiers.each do |notifier|
            notifier.notify(incidents)
          end
        end
        sleep(@poll_interval)
      end
    end
  end
end
