# @summary configures the main fluentbit main config
#
# Creates a puppet resource for every service, input, ouptut
# Doesn't support filters (yet)
# Includes all [service], [input] and [output] configs. (@include)
# Sets global variables (@set)
#
# @private
#   include fluentbit::config
class fluentbit::config(
  Optional[String]  $configfile = '/etc/td-agent-bit/td-agent-bit.conf',
  ) {
  assert_private()

  # create configfile
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('td-agent-bit.conf.erb'),
    notify  => Service['td-agent-bit'],
  }
  # create service resource
  # create input resource
  # create output resource
}
