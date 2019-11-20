# @summary configures the fluentbit repo
#
# @private
class fluentbit::repo {
  assert_private()

  if $fluentbit::manage_package_repo {
    case $facts['os']['family'] {
      'Debian': {
        contain '::fluentbit::repo::debian'
      }
      default: {
        fail("${module_name} module doesn't support ${facts['os']['family']}")
      }
    }
  }
}
