require 'spec_helper'


describe 'cnmon_sensu', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with default values for all parameters' do
        it { is_expected.to compile.and_raise_error(/Invalid env_name/) }
      end

      describe 'with default values for all parameters with env_name' do
        let(:params) do
          {
            :env_name => 'cnbebop'
          }
        end

        it { is_expected.to create_class('cnmon_sensu') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('cnmon_sensucert::env::sensu') }
        it { is_expected.to contain_class('sensu').with(
          :server => false,
        ) }
      end

      describe 'server => true' do
        let(:params) do
          {
            :env_name => 'cnbebop',
            :server   => true,
          }
        end

        it { is_expected.to contain_class('sensu').with(
          :server => true,
        ) }
      end
    end
  end
end
