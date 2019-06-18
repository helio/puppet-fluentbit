# @summary Installs and configures fluentbit
#
# @param manage_package_repo Installs the package repositories
# @param ensure Add or remove the software
#
# @example
#   include fluentbit
class fluentbit(
  Boolean $manage_package_repo = true,
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
}
