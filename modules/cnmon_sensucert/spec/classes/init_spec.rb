require 'spec_helper'


describe 'cnmon_sensucert', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      # let(:pre_condition) { ['include ::sensu', 'include ::rabbitmq'] }
      let(:pre_condition) {[
        "class {'::sensu':
            rabbitmq_ssl                => true,
            rabbitmq_ssl_private_key    => '/etc/sensu/ssl/key.pem',
            rabbitmq_ssl_cert_chain     => '/etc/sensu/ssl/cert.pem',
        }", 'include ::rabbitmq']
      }
      let(:facts) do
        facts
      end

      describe 'with default values for all parameters' do
        it { is_expected.to create_class('cnmon_sensucert') }
        it { is_expected.to compile.with_all_deps }
      end

      describe 'with an environment' do
        let(:params) do
          {
            :env => 'rabbitmq',
          }
        end
        it { is_expected.to contain_class("cnmon_sensucert::env::#{params[:env]}") }
      end
    end
  end
end
