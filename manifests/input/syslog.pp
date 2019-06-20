# @summary Ingest logs from (r)syslog
#
# Setups config file for fluentbit and configures listen
# on rsyslog. Reloads services if something changes.
#
# @param mode
#  Defines transport protocol mode: unix_udp (UDP over Unix socket), unix_tcp (TCP over Unix socket), tcp or udp
# @param listen
#  If Mode is set to tcp, specify the network interface to bind.
# @param port
#  If Mode is set to tcp, specify the TCP port to listen for incoming connections.
# @param path
#  If Mode is set to unix_tcp or unix_udp, set the absolute path to the Unix socket file.
# @param parser
#  Specify an alternative parser for the message. By default, the plugin uses the parser syslog-rfc3164.
#  If your syslog messages have fractional seconds set this Parser value to syslog-rfc5424 instead.
# @param rsyslog_config
#  Specify the path to the rsyslog config file for fluentbit to enable listening.
# @param configfile
#  Path to the input configfile. Naming should be input_*.conf to make sure
#  it's getting included by the main config.
#
define fluentbit::input::syslog(
  String $mode = 'unix_udp',
  Optional[String] $listen = $mode ? {
    tcp => '0.0.0.0',
    default => undef
  },
  Optional[String] $port   = $mode ? {
    tcp => '5140',
    default => undef,
  },
  Optional[String] $path   = $mode ? {
    unix_tcp => '/tmp/fluent-bit.sock',
    unix_udp => '/tmp/fluent-bit.sock',
    default  => undef,
  },
  String $parser = 'syslog-rfc3164',
  String $configfile = '/etc/td-agent-bit/input_syslog.conf',
  String $rsyslog_config = '/etc/rsyslog.d/60-fluent-bit.conf',
) {
  # create input_syslog.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/input/syslog.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
  # create rsyslog config and reload service
  file { $rsyslog_config:
    ensure  => file,
    mode    => '0644',
    notify  => Service['rsyslog'],
    content => '$ModLoad omuxsock
$OMUxSockSocket /tmp/fluent-bit.sock
*.* :omuxsock:',
  }
}
