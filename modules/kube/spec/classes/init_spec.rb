require 'spec_helper'
describe 'kube' do

  context 'with defaults for all parameters' do
    it { should contain_class('kube') }
  end
end
