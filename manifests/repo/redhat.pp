# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include fluentbit::repo::redhat
class fluentbit::repo::redhat {
  assert_private()

  $family = dig($facts, 'os', 'family')
  $os_name = dig($facts, 'os', 'name')

  if $family == 'RedHat' {
    $baseurl = "https://packages.fluentbit.io/centos/7/\$basearch/"
  } else {
    fail("OS ${family}/${os_name} is not supported")l
  }

  contain '::yum'

  yumrepo { 'fluentbit':
    descr         => 'Official Treasure Data repository for Fluent-Bit',
    gpgkey        => 'https://packages.fluentbit.io/fluentbit.key',
    baseurl       => $baseurl,
    enabled       => '1',
    gpgcheck      => '1',
    repo_gpgcheck => '0',
  }

  Yumrepo['fluentbit'] -> Package['fluentbit']
}
