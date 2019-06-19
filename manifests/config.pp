# @summary configures the main fluentbit main config
#
# Creates a puppet resource for every input, ouptut config
# Doesn't support filters (yet)
# Includes all [input] and [output] configs. (@include)
# Sets global variables (@set)
# Configures global [service] section
#
# @param flush
#   Set the flush time in seconds. Everytime it timeouts, the engine will flush the records to the output plugin.
# @param daemon
#   Boolean value to set if Fluent Bit should run as a Daemon (background) or not. Allowed values are: yes, no, on and off.
# @param log_file
#   Absolute path for an optional log file.
# @param log_level
#  Set the logging verbosity level. Allowed values are: error, info, debug and trace. Values are accumulative,
#  e.g: if 'debug' is set, it will include error, info and debug.
#  Note that trace mode is only available if Fluent Bit was built with the WITH_TRACE option enabled.
# @param parsers_file
#  Path for a parsers configuration file. Multiple Parsers_File entries can be used.
# @param plugins_file
#  Path for a plugins configuration file. A plugins configuration file allows to define paths for external plugins, for an example see here.
# @param streams_file
#  Path for the Stream Processor configuration file.
# @param http_server
#  Enable built-in HTTP Server
# @param http_listen
#  Set listening interface for HTTP Server when it's enabled
# @param http_port
#  Set TCP Port for the HTTP Server
# @param coro_stack_size
#  Set the coroutines stack size in bytes. The value must be greater than the page size of the running system.
#
# @private
#   include fluentbit::config
class fluentbit::config(
  String $configfile             = '/etc/td-agent-bit/td-agent-bit.conf',
  Integer $flush                 = 5,
  Enum['on', 'off'] $daemon      = off,
  Optional[String] $log_file     = undef,
  String $log_level              = info, # TODO: Enum
  Optional[String] $parsers_file = undef, #TODO: map e.g. nginx with nginx.conf
  Optional[String] $plugins_file = undef,
  Optional[String] $streams_file = undef,
  Enum['on', 'off'] $http_server = off,
  String $http_listen            = '0.0.0.0',
  String $http_port              = '2020',
  String $coro_stack_size        = '24576',
) {
  assert_private()

  # create configfile
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/td-agent-bit.conf.erb'),
    notify  => Service['$::fluentbit::service_name'], # TODO: get service name from params
  }
}
