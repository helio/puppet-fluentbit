# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
# == Define: define_name
#
define fluentbit::input::syslog(
  Optional[String] $mode = 'unix_udp',
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
  Optional[String] $parser = 'syslog-rfc3164',
  Optional[String] $configfile = '/etc/td-agent-bit/input_syslog.conf',
  Optional[String] $rsyslog_config = '/etc/rsyslog.d/60-fluent-bit.conf',
) {
  # create input_syslog.conf
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/input/syslog.conf.erb'),
    notify  => Service['td-agent-bit'], # TODO: get service name from params
  }
  # create rsyslog config
  file { $rsyslog_config:
    ensure  => file,
    mode    => '0644',
    notify  => Service['rsyslog'],
    content => '$ModLoad omuxsock
$OMUxSockSocket /tmp/fluent-bit.sock
*.* :omuxsock:',
  }
}
