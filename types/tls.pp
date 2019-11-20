type Fluentbit::TLS = Struct[{
  Optional[enabled]    => Boolean,
  Optional[verify]     => Boolean,
  Optional[debug]      => Boolean,
  Optional[ca_file]    => Stdlib::Absolutepath,
  Optional[ca_path]    => Stdlib::Absolutepath,
  Optional[crt_file]   => Stdlib::Absolutepath,
  Optional[key_file]   => Stdlib::Absolutepath,
  Optional[key_passwd] => String[1],
  Optional[vhost]      => Stdlib::Fqdn,
}]
