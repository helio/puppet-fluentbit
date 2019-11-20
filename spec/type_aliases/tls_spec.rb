require 'spec_helper'

describe 'Fluentbit::TLS' do
  it do
    is_expected.to allow_values(
      {
        enabled: true,
        verify: true,
        debug: false,
        ca_file: '/etc/ssl/certs/ca.pem',
        ca_path: '/etc/ssl/certs/',
        crt_file: '/etc/ssl/certs/rspec.crt',
        key_file: '/etc/ssl/private/rspec.key',
        key_passwd: 'secret',
        vhost: 'rspec.example.com',
      },
      {
        enabled: true,
        verify: false,
      },
      {}
    )
  end
end
