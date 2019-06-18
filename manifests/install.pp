# @summary Installs fluentbit package
#
# @private
class fluentbit::install (
  ) {
  assert_private()

  # install package
  Package{ 'td-agent-bit':
    ensure => present,
  }
}
