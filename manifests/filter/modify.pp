# @summary Filter to modify records using rules and conditions
#
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
  String $configfile                = '/etc/td-agent-bit/filters  _modify.conf',
  String $match                     = '*',
  Optional[Array] $set              = undef,
  Optional[Array] $add              = undef,
  Optional[Array] $remove           = undef,
  Optional[String] $remove_wildcard = undef,
  Optional[String] $remove_regex    = undef,
  Optional[Array] $rename           = undef,
  Optional[Array] $hard_rename      = undef,
  Optional[Array] $copy             = undef,
  Optional[Array] $hard_copy        = undef,
) {
  # create filter_modify.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/modify.conf.erb'),
    notify  => Class['fluentbit::service'],
  }
}
