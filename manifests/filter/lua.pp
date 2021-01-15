define fluentbit::filter::lua (
  String $configfile         = "/etc/td-agent-bit/filter_lua_${name}.conf",
  String $match              = '*',
  String $script             = undef,
  String $call               = undef,
) {
  # create filter_modify.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/lua.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
