require 'spec_helper'
describe 'mq' do

  context 'with defaults for all parameters' do
    it { should contain_class('mq') }
  end
end
