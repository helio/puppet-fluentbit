# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @params TODO
#
# @example
# == Define: define_name
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
    notify  => Service['$::fluentbit::service_name'], # TODO: get service name from params
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
