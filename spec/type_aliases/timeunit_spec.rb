require 'spec_helper'

describe 'Fluentbit::Timeunit' do
  it do
    is_expected.to allow_values(
      '1',
      '23',
      '45m',
      '67h',
      '89d',
    )
  end
  it do
    is_expected.not_to allow_values(
      '',
      'X',
      '1s',
      '1 h',
      '1w',
      '1M',
    )
  end
end
