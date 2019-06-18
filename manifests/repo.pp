# @summary configures the fluentbit repo
#
# @private
class fluentbit::repo (
  Enum['present', 'absent'] $ensure = 'present',
  ) {
  assert_private()

  # configure apt key for debian and ubuntu
  if $facts["os"]["name"] == 'Debian' or $facts["os"]["name"] == 'Ubuntu' {
    apt::key { 'fluentbit':
      source => 'https://packages.fluentbit.io/fluentbit.key',
      server => 'packags.fluentbit.io',
      id     => 'F209D8762A60CD49E680633B4FF8368B6EA0722A',
    }
  } else {
    fail(sprintf("Fluentbit module doesn't support %s", $facts["os"]["family"]))
  }

  # configure source
  if $facts["os"]["name"] == 'Ubuntu'{

    # check if release is supported
    if versioncmp($facts['os']['release']['major'], '16.04') < 0 {
      fail('Fluentbit Repositories are only supported for xenial or newer releases')
    } elsif versioncmp($facts['os']['release']['major'], '17.10') > 0 {
      $release = 'bionic'
    } else {
      $release = 'xenial'
    }
    # add source
    apt::source { 'fluentbit':
      notify_update => true,
      location      => "https://packages.fluentbit.io/ubuntu/${release}",
      release       => $release,
      repos         => 'main',
    }
  } elsif $facts["os"]["name"] == 'Debian'{
    $release = $facts['os']['distro']['codename']
    # add source
    apt::source { 'fluentbit':
      notify_update => true,
      location      => "https://packages.fluentbit.io/debian/${release}",
      release       => $release,
      repos         => 'main',
    }
  }
}
