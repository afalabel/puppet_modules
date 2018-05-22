require 'spec_helper'


describe 'cnmon_sensucert::env::sensu', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      # let(:pre_condition) { 'include ::sensu' }
      let(:pre_condition) {[
        "class {'::sensu':
            rabbitmq_ssl                => true,
            rabbitmq_ssl_private_key    => '/etc/sensu/ssl/key.pem',
            rabbitmq_ssl_cert_chain     => '/etc/sensu/ssl/cert.pem',
        }"]
      }
      let(:facts) do
        facts
      end

      it { is_expected.to contain_file('/etc/sensu/ssl/cert.pem').with(
        'ensure' => 'file',
        'owner'  => 'sensu',
        'group'  => 'sensu',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cnmon_sensucert/sensu/cert.pem',
      )}

      it { is_expected.to contain_file('/etc/sensu/ssl/key.pem').with(
        'ensure' => 'file',
        'owner'  => 'sensu',
        'group'  => 'sensu',
        'mode'   => '0400',
        'source' => 'puppet:///modules/cnmon_sensucert/sensu/key.pem',
      )}
    end
  end
end
