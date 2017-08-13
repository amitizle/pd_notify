
# lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'pd_notify')
# Dir.glob(File.join(lib_dir, '**', '*')).reject {|f| File.directory?(f)}.each do |f|
#   require f
# end

require 'time'
require 'optparse'
require 'pd_notify/http_client'
require 'pd_notify/notifiers/mac'
require 'pd_notify/utils/config'
require 'pd_notify/api'

config_dir = File.join(File.expand_path(__dir__), '..', 'config')
$default_file_path = File.join(config_dir, 'defaults.yml')
$config_file_path = File.expand_path('~/.config/pdnotify/config.yml')

global_opts = OptionParser.new do |parser|
  parser.on('-c', '--config <path>', String, "Path to config file, defaults to #{$config_file_path}") do |config_path|
    $config_file_path = config_path
  end
end

PdNotify::Utils::Config.init($config_file_path, $default_file_path)

config = PdNotify::Utils::Config.instance
$poll_interval = config.get('poll_interval_seconds') || config.default('poll_interval_seconds')
$app_icon_url = config.get('app_icon_url') || config.default('app_icon_url')
$incidents_opts = {
  users: config.get('users') || config.default('users'),
  services: config.get('services') || config.default('services'),
  urgencies: config.get('urgencies') || config.default('urgencies'),
  statuses: config.get('statuses') || config.default('statuses'),
  time_zone: 'UTC'
}
$notifiers = [
  PdNotify::Notifiers::Mac.new
]
$http_client = PdNotify::HTTPClient.new

$last_check_time = Time.now.utc.iso8601
loop do
  response = PdNotify::API::V2::Incidents.list($http_client, $incidents_opts.merge({since: $last_check_time}))
  incidents = response['incidents']
  $last_check_time = Time.now.utc.iso8601
  if !incidents.empty?
    $notifiers.each do |notifier|
      notifier.notify(incidents)
    end
  end
  sleep($poll_interval)
end
