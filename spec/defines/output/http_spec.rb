require 'spec_helper'

describe 'fluentbit::output::http' do
  let(:title) { 'rspec' }
  let(:pre_condition) do
    <<-MANIFEST
class { 'fluentbit':
  manage_package_repo => false,
}
MANIFEST
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {}
      end

      context 'with default parameters' do
        let(:params) do
          super().merge({})
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with tls' do
        let(:params) do
          super().merge(
            match: '*',
            host: '192.168.2.3',
            port: 80,
            uri: '/something',
            tls: {
              enabled: true,
              verify: false,
            },
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Match                  *
    Host                   192.168.2.3
    Port                   80
    URI                    /something
    tls                    On
    tls.verify             Off
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'without a retry limit' do
        let(:params) do
          super().merge(
            retry_limit: false,
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Retry_Limit            False
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with a boolean retry limit' do
        let(:params) do
          super().merge(
            retry_limit: true,
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Retry_Limit            1
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with a retry limit' do
        let(:params) do
          super().merge(
            retry_limit: 5,
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Retry_Limit            5
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with message header' do
        let(:params) do
          super().merge(
            match: '*',
            host: 'logstash.example.com',
            port: 80,
            uri: '/something',
            format: 'json',
            header_tag: 'FLUENT-TAG',
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Match                  *
    Host                   logstash.example.com
    Port                   80
    URI                    /something
    Format                 json
    header_tag             FLUENT-TAG
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with message header' do
        let(:params) do
          super().merge(
            match: '*',
            host: '127.0.0.1',
            port: 9000,
            uri: '/something',
            headers: {
              'X-Key-A' => 'Value_A',
              'X-Key-B' => 'Value_B',
            },
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[OUTPUT]
    Name                   http
    Match                  *
    Host                   127.0.0.1
    Port                   9000
    URI                    /something
    Header                 X-Key-A Value_A
    Header                 X-Key-B Value_B
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/output_http_rspec.conf')
            .with_content(rendered)
        end
      end
    end # on os
  end # on_supported_os
end
