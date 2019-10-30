# @summary Manage the configuration of a HTTP output plugin.
#
# The http output plugin allows to flush your records into a HTTP endpoint.
# This type manages the configuration for it.
#
# @param configfile
#  Path to the output configfile. Naming should be output_*.conf to make sure
#  it's getting included by the main config.
#
# @param match
#  Tag to route the output.
#
# @param tls
#   TLS configuration. By default TLS is disabled.
#
# @param headers
#   Map of headers to add to requests.
#
# @param retry_limit
#   Number of retries if upstream refuses the records.
#   *false* will disable retries, *true* will cause it to retry once.
#   All other values are passed on verbatim.
#
# @param host
#   IP address or hostname of the target HTTP Server.
#
# @param port
#   TCP port of the target HTTP Server.
#
# @param http_user
#   Basic Auth Username.
#
# @param http_passwd
#   Basic Auth Password.
#   Requires HTTP_User to be set.
#
# @param proxy
#   Specify an HTTP Proxy.
#
# @param uri
#   Specify an optional HTTP URI for the target web server.
#
# @param format
#   Specify the data format to be used in the HTTP request body.
#
# @param header_tag
#   Specify an optional HTTP header field for the original message tag.
#
# @param json_date_key
#   Specify the name of the date field in output.
#
# @param json_date_format
#   Specify the format of the date.
#
# @param gelf_timestamp_key
#   Specify the key to use for *timestamp* in **gelf** format.
#
# @param gelf_host_key
#   Specify the key to use for *host* in **gelf** format.
#
# @param gelf_short_messge_key
#   Specify the key to use for *short* in **gelf** format.
#
# @param gelf_full_message_key
#   Specify the key to use for *full* in **gelf** format.
#
# @param gelf_level_key
#   Specify the key to use for *level* in **gelf** format.
#
# @example
#   fluentbit::output::http { 'logstash': }
define fluentbit::output::http (
  Stdlib::Absolutepath $configfile            = "/etc/td-agent-bit/output_http_${name}.conf",
  Fluentbit::TLS $tls                         = {},
  Hash[String[1], String[1]] $headers         = {},
  Variant[Undef, Boolean, Integer[1]]
    $retry_limit                              = undef,
  Optional[String[1]] $match                  = undef,
  Optional[Stdlib::Host] $host                = undef,
  Optional[Stdlib::Port] $port                = undef,
  Optional[String[1]] $http_user              = undef,
  Optional[String[1]] $http_passwd            = undef,
  Optional[Stdlib::HTTPUrl] $proxy            = undef,
  Optional[Stdlib::Absolutepath] $uri         = undef,
  Optional[Enum['msgpack', 'json', 'json_stream', 'json_lines', 'gelf']]
    $format                                   = undef,
  Optional[String[1]] $header_tag             = undef,
  Optional[String[1]] $json_date_key          = undef,
  Optional[Enum['double', 'iso8601']]
    $json_date_format                         = undef,
  Optional[String[1]] $gelf_timestamp_key     = undef,
  Optional[String[1]] $gelf_host_key          = undef,
  Optional[String[1]] $gelf_short_messge_key  = undef,
  Optional[String[1]] $gelf_full_message_key  = undef,
  Optional[String[1]] $gelf_level_key         = undef,
) {

  if empty($http_user) and !empty($http_passwd) {
    fail('HTTP username must be provided when basic authentication is used')
  }

  $tls_enabled = $tls['enabled'] ? {
    undef   => undef,
    default => bool2str($tls['enabled'], 'On', 'Off'),
  }
  $tls_verify = $tls['verify'] ? {
    undef   => undef,
    default => bool2str($tls['verify'], 'On', 'Off'),
  }
  $tls_debug = $tls['debug'] ? {
    undef   => undef,
    default => bool2str($tls['debug'], 'On', 'Off'),
  }
  $tls_ca_file = $tls['ca_file']
  $tls_ca_path = $tls['ca_path']
  $tls_crt_file = $tls['crt_file']
  $tls_key_file = $tls['key_file']
  $tls_key_passwd = $tls['key_passwd']
  $tls_vhost = $tls['vhost']

  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/http.conf.erb'),
    notify  => Class['fluentbit::service'],
  }
}
