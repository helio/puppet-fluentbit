# @summary
#
# A description of what this class does
#
# @example
#   include fluentbit::input
class fluentbit::input (
    Optional[Hash] $plugins = { 'syslog' => {},}
  ){
    $plugins.each | String $plugin, Hash $attributes | {
      Resource[fluentbit::inputs] {
        $plugin: * => $attributes;
        default:   * => $defaults;
      }
    }
  }
