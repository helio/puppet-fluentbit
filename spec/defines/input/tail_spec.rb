require 'spec_helper'

describe 'fluentbit::input::tail' do
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
        {
          path: '/var/log/test/*.log',
        }
      end

      context 'with default parameters' do
        let(:params) do
          super().merge({})
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Path              /var/log/test/*.log
    Skip_Long_Lines   Off
    Docker_Mode       Off
    Multiline         Off
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with tag and DB' do
        let(:params) do
          super().merge(
            routing_tag: 'rspec',
            db: '/var/lib/fluentbit/tail_rspec.db',
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Tag               rspec
    Path              /var/log/test/*.log
    Skip_Long_Lines   Off
    DB                /var/lib/fluentbit/tail_rspec.db
    Docker_Mode       Off
    Multiline         Off
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with parser' do
        let(:params) do
          super().merge(
            parsers: ['test', 'unused'],
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Path              /var/log/test/*.log
    Skip_Long_Lines   Off
    Docker_Mode       Off
    Multiline         Off
    Parser            test
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with multiline' do
        let(:params) do
          super().merge(
            multiline: true,
            parsers: ['test', 'rspec', 'example'],
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Path              /var/log/test/*.log
    Skip_Long_Lines   Off
    Docker_Mode       Off
    Multiline         On
    Parser_Firstline  test
    Parser_1  rspec
    Parser_2  example
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'kubernetes logs' do
        let(:params) do
          super().merge(
            path: '/var/log/containers/*.log',
            routing_tag: 'kube.*',
            parsers: ['docker'],
            mem_buf_limit: '5MB',
            docker_mode: true,
            skip_long_lines: true,
            refresh_interval: 10,
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Tag               kube.*
    Path              /var/log/containers/*.log
    Refresh_Interval  10
    Skip_Long_Lines   On
    Mem_Buf_Limit     5MB
    Docker_Mode       On
    Multiline         Off
    Parser            docker
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'parsing a java app logfile' do
        let(:params) do
          super().merge(
            routing_tag: 'app',
            path: '/var/log/app/*.log',
            multiline: true,
            parsers: ['java_multiline'],
            exclude_path: ['*.gz', '*.xz'],
          )
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[INPUT]
    Name              tail
    Tag               app
    Path              /var/log/app/*.log
    Skip_Long_Lines   Off
    Docker_Mode       Off
    Exclude_Path      *.gz,*.xz
    Multiline         On
    Parser_Firstline  java_multiline
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/input_tail_rspec.conf')
            .with_content(rendered)
        end
      end
    end # on os
  end # on_supported_os
end
