require 'spec_helper'


describe 'cnmon_sensucert::env::rabbitmq', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) { 'include ::rabbitmq' }
      let(:facts) do
        facts
      end

      it { is_expected.to contain_file('/etc/rabbitmq/ssl/cacert.pem').with(
        'ensure' => 'file',
        'owner'  => 'rabbitmq',
        'group'  => 'rabbitmq',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cnmon_sensucert/rabbitmq/cacert.pem',
      )}

      it { is_expected.to contain_file('/etc/rabbitmq/ssl/cert.pem').with(
        'ensure' => 'file',
        'owner'  => 'rabbitmq',
        'group'  => 'rabbitmq',
        'mode'   => '0644',
        'source' => 'puppet:///modules/cnmon_sensucert/rabbitmq/cert.pem',
      )}

      it { is_expected.to contain_file('/etc/rabbitmq/ssl/key.pem').with(
        'ensure' => 'file',
        'owner'  => 'rabbitmq',
        'group'  => 'rabbitmq',
        'mode'   => '0400',
        'source' => 'puppet:///modules/cnmon_sensucert/rabbitmq/key.pem',
      )}
    end
  end
end
