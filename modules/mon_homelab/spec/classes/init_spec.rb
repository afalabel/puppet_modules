require 'spec_helper'
describe 'mon_homelab' do

  context 'with defaults for all parameters' do
    it { should contain_class('mon_homelab') }
  end
end
