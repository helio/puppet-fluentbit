# @summary Filter to modify records using rules and conditions
#
# @param configfile
#  Path to the filter configfile. Naming should be filter_*.conf to make sure
#  it's getting included by the main config.
# @param set
#  Add a key/value pair with key KEY and value VALUE.
#  If KEY already exists, this field is overwritten
# @param add
#  Add a key/value pair with key KEY and value VALUE if KEY does not exist
# @param remove
#  Remove a key/value pair with key KEY if it exists
# @param remove_wildcard
#  Remove all key/value pairs with key matching wildcard KEY
# @param remove_regex
#  Remove all key/value pairs with key matching regexp KEY
# @param rename
#  Rename a key/value pair with key KEY to RENAMED_KEY if KEY exists AND RENAMED_KEY does not exist
# @param hard_rename
#  Rename a key/value pair with key KEY to RENAMED_KEY if KEY exists.
#  If RENAMED_KEY already exists, this field is overwritten
# @param copy
#  Copy a key/value pair with key KEY to COPIED_KEY if KEY exists AND COPIED_KEY does not exist
# @param hard_copy
#  Copy a key/value pair with key KEY to COPIED_KEY if KEY exists.
#  If COPIED_KEY already exists, this field is overwritten
# @example
#   fluentbit::filter::modify { 'namevar': }
define fluentbit::filter::modify (
  Stdlib::Absolutepath $configfile = "/etc/td-agent-bit/plugins.d/filter_modify_${name}.conf",
  String $match              = '*',
  Optional $set              = undef,
  Optional $add              = undef,
  Optional $remove           = undef,
  Optional $remove_wildcard  = undef,
  Optional $remove_regex     = undef,
  Optional $rename           = undef,
  Optional $hard_rename      = undef,
  Optional $copy             = undef,
  Optional $hard_copy        = undef,
) {
  # create filter_modify.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/modify.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
