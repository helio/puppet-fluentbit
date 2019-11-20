# @summary Installs fluentbit package
#
# @private
class fluentbit::install {
  assert_private()

  package{ 'fluentbit':
    ensure => $fluentbit::package_ensure,
    name   => $fluentbit::package_name,
  }
}
