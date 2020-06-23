# @summary Plugin to output logs to newrelic
#
# https://github.com/newrelic/newrelic-fluent-bit-output
#
# @example
#   fluentbit::output::newrelic { 'newrelic': }
define fluentbit::output::newrelic (
  Stdlib::Absolutepath
    $configfile = "/etc/td-agent-bit/output_newrelic_${name}.conf",
  String $match = '*',
  String $licenseKey = undef,
  Optional[String] $apiKey = undef,
  Optional[Stdlib::HTTPUrl] $endpoint = undef,
  Optional[Integer[1]] $maxBufferSize = undef,
  Optional[Integer[1]] $maxRecords = undef,
  Optional[String] $proxy = undef,
  Optional[Enum['true', 'false']] $ignoreSystemProxy = undef,
  Optional[Stdlib::Absolutepath] $caBundleFile = undef,
  Optional[Stdlib::Absolutepath] $caBundleDir = undef,
  Optional[Enum['true', 'false']] $validateProxyCerts = undef,
) {
  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/newrelic.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
