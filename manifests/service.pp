# @summary Manages the td-agent-bit service
#
# @private
class fluentbit::service {
  assert_private()

  # manage service
  service { '$::fluentbit::service_name':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
