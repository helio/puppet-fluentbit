require 'spec_helper'

describe 'fluentbit::filter::modify' do
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
      let(:params) { {} }

      context 'with default parameters' do
        let(:params) do
          super().merge({})
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[FILTER]
    Name                                                modify
    Match                                               *
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/filter_modify_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with rule parameters' do
        let(:params) do
          super().merge({
            remove: [ 'remove', 'delete' ],
            remove_wildcard: [ 'wild*', 'card*' ],
            remove_regex: [ 'regex.+', 'pattern.*' ],
            set: {
              set: 'this',
              test: 'rspec',
            },
            add: {
              key: 'value',
              rule: 'test',
            },
            rename: {
              old: 'new',
              this: 'that',
            },
            hard_rename: {
              force_old: 'force_new',
              force_this: 'force_that',
            },
            copy: {
              source: 'target',
              origin: 'destination',
            },
            hard_copy: {
              force_source: 'force_target',
              force_origin: 'force_destination',
            },
          })
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[FILTER]
    Name                                                modify
    Match                                               *
    Set                                                 set this
    Set                                                 test rspec
    Add                                                 key value
    Add                                                 rule test
    Remove                                              remove
    Remove                                              delete
    Remove_wildcard                                     wild*
    Remove_wildcard                                     card*
    Remove_regex                                        regex.+
    Remove_regex                                        pattern.*
    Rename                                              old new
    Rename                                              this that
    Hard_rename                                         force_old force_new
    Hard_rename                                         force_this force_that
    Copy                                                source target
    Copy                                                origin destination
    Hard_copy                                           force_source force_target
    Hard_copy                                           force_origin force_destination
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/filter_modify_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with rule parameters' do
        let(:params) do
          super().merge({
            key_exists: ['exist', 'present'],
            key_does_not_exist: ['not_exist', 'absent'],
            a_key_matches: ['regex.*', 'pattern.*'],
            no_key_matches: ['no_.+', 'missing_.+'],
            key_value_equals: {
              key_value_equals: 'check',
              check_key_value_equals: 'true',
            },
            key_value_does_not_equal: {
              key_value_does_not_equal: 'check',
              check_key_value_does_not_equal: 'true',
            },
            key_value_matches: {
              key_value_matches: 'check',
              check_key_value_matches: 'true',
            },
            key_value_does_not_match: {
              key_value_does_not_match: 'check',
              check_key_value_does_not_match: 'true',
            },
            matching_keys_have_matching_values: {
              matching_keys_have_matching_values: 'check',
              check_matching_keys_have_matching_values: 'true',
            },
            matching_keys_do_not_have_matching_values: {
              matching_keys_do_not_have_matching_values: 'check',
              check_matching_keys_do_not_have_matching_values: 'true',
            },

            set: {
              'this_plugin_is_on': '🔥',
            },
          })
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[FILTER]
    Name                                                modify
    Match                                               *
    Condition Key_exists                                exist
    Condition Key_exists                                present
    Condition Key_does_not_exist                        not_exist
    Condition Key_does_not_exist                        absent
    Condition A_key_matches                             regex.*
    Condition A_key_matches                             pattern.*
    Condition No_key_matches                            no_.+
    Condition No_key_matches                            missing_.+
    Condition Key_value_equals                          key_value_equals check
    Condition Key_value_equals                          check_key_value_equals true
    Condition Key_value_does_not_equal                  key_value_does_not_equal check
    Condition Key_value_does_not_equal                  check_key_value_does_not_equal true
    Condition Key_value_matches                         key_value_matches check
    Condition Key_value_matches                         check_key_value_matches true
    Condition Key_value_does_not_match                  key_value_does_not_match check
    Condition Key_value_does_not_match                  check_key_value_does_not_match true
    Condition Matching_keys_have_matching_values        matching_keys_have_matching_values check
    Condition Matching_keys_have_matching_values        check_matching_keys_have_matching_values true
    Condition Matching_keys_do_not_have_matching_values matching_keys_do_not_have_matching_values check
    Condition Matching_keys_do_not_have_matching_values check_matching_keys_do_not_have_matching_values true
    Set                                                 this_plugin_is_on 🔥
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/filter_modify_rspec.conf')
            .with_content(rendered)
        end
      end

      context 'with single value parameters' do
        let(:params) do
          super().merge({
            remove: 'key',
            remove_wildcard: 'wildcard*',
            remove_regex: 'regex.*',
          })
        end
        let(:rendered) do
          <<EOF
# Managed by puppet
[FILTER]
    Name                                                modify
    Match                                               *
    Remove                                              key
    Remove_wildcard                                     wildcard*
    Remove_regex                                        regex.*
EOF
        end

        it do
          is_expected.to contain_file('/etc/td-agent-bit/plugins.d/filter_modify_rspec.conf')
            .with_content(rendered)
        end
      end
    end
  end
end
