# @summary Installs and configures fluentbit
#
# @example
#   include fluentbit
# @see https://docs.fluentbit.io/manual/
#
# @param manage_package_repo Installs the package repositories
# @param create_defaults create some fluetbit example files (syslog, es, filers)
# @param service_name the td-agent-bit service name
# @param input_plugins Hash of the INPUT plugins to be configured
# @param output_plugins Hash of the OUTPUT plugins to be configured
# @param filters Hash of the filter to be configured
#
class fluentbit(
  # module configs
  Boolean $manage_package_repo = true,
  Boolean $create_defaults     = false,
  String $service_name         = 'td-agent-bit',
  ### START Hiera Lookups ###
  Hash $input_plugins          = $create_defaults ? {
    true => { 'syslog' => { mode => unix_udp, }},
    false => {}
    },
  Hash $output_plugins         = $create_defaults ? {
    true => { 'es' => {}},
    false => {}
    },
  Hash $filters                = $create_defaults ? {
    true => { 'modify' => {}},
    false => {}
    },
  ) {
  # configures repo if enabled
  if $manage_package_repo {
    class{'fluentbit::repo':
      before => Class['fluentbit::install']
    }
  }
  # install package and configure td-agent-bit with service
  class{'fluentbit::install': }
    -> class{'fluentbit::config': }
    -> class{'fluentbit::service': }
  contain fluentbit::install
  contain fluentbit::service

  # use create resources to define resources
  # input plugins
  $input_plugins.each | String $plugin, Hash $attributes | {
    Resource["fluentbit::input::${plugin}"] {
      $plugin: * => $attributes;
    }
  }
  # output plugins
  $output_plugins.each | String $plugin, Hash $attributes | {
    Resource["fluentbit::input::${plugin}"] {
      $plugin: * => $attributes;
    }
  }
  # filter plugins
  $output_plugins.each | String $plugin, Hash $attributes | {
    Resource["fluentbit::input::${plugin}"] {
      $plugin: * => $attributes;
    }
  }
}
