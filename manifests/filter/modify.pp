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
# @param key_exists
#   Is true if KEY exists
# @param key_does_not_exist
#   Is true if KEY does not exist
# @param a_key_matches
#   Is true if a key matches regex KEY
# @param no_key_matches
#   Is true if no key matches regex KEY
# @param key_value_equals
#   Is true if KEY exists and its value is VALUE
# @param key_value_does_not_equal
#   Is true if KEY exists and its value is not VALUE
# @param key_value_matches
#   Is true if key KEY exists and its value matches VALUE
# @param key_value_does_not_match
#   Is true if key KEY exists and its value does not match VALUE
# @param matching_keys_have_matching_values
#   Is true if all keys matching KEY have values that match VALUE
# @param matching_keys_do_not_have_matching_values
#   Is true if all keys matching KEY have values that do not match VALUE
# @example
#   fluentbit::filter::modify { 'namevar': }
define fluentbit::filter::modify (
  String $configfile         = '/etc/td-agent-bit/filter_modify.conf',
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
  Array[String[1]] $key_exists                                          = [],
  Array[String[1]] $key_does_not_exist                                  = [],
  Array[String[1]] $a_key_matches                                       = [],
  Array[String[1]] $no_key_matches                                      = [],
  Hash[String[1], String[1]] $key_value_equals                          = {},
  Hash[String[1], String[1]] $key_value_does_not_equal                  = {},
  Hash[String[1], String[1]] $key_value_matches                         = {},
  Hash[String[1], String[1]] $key_value_does_not_match                  = {},
  Hash[String[1], String[1]] $matching_keys_have_matching_values        = {},
  Hash[String[1], String[1]] $matching_keys_do_not_have_matching_values = {},
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
