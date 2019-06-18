# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include fluentbit::ouptput
class fluentbit::ouptput {
  Optional[Hash] $output_plugins = { 'es' => { }},
){
  $output_plugins.each | String $plugin, Hash $attributes | {
    Resource["fluentbit::output::${plugin}"] {
      $plugin: * => $attributes;
    }
  }
}
