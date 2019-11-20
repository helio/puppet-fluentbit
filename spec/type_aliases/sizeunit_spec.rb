require 'spec_helper'

describe 'Fluentbit::Sizeunit' do
  it do
    is_expected.to allow_values(
      '1',
      '23',
      '45k',
      '67K',
      '89mB',
      '1011Gb',
      '1213GB',
    )
  end
  it do
    is_expected.not_to allow_values(
      '',
      'X',
      '1b',
      '1 k',
      '1t',
      '1TB',
    )
  end
end
