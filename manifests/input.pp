# @summary
#
# A description of what this class does
#
# @example
#   include fluentbit::input
class fluentbit::input (
    Optional[Hash] $input_plugins = { 'syslog' => { mode => unix_udp, }},
  ){
    $input_plugins.each | String $plugin, Hash $attributes | {
      Resource["fluentbit::input::${plugin}"] {
        $plugin: * => $attributes;
      }
    }
  }
