require 'spec_helper'

describe 'perfsonar::bwctl', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_package('bwctl') }
    it { should contain_package('bwctl-server') }
    it { should contain_package('bwctl-client') }
    it { should contain_package('iperf') }
    it { should contain_package('nuttcp') }
  end

  context 'manage_service =>' do
    context 'true' do
      let(:params) {{ :manage_service => true }}

      it { should contain_service('bwctl') }
    end

    context 'false' do
      let(:params) {{ :manage_service => false }}

      it { should_not contain_service('bwctl') }
    end

    context 'foo' do
      let(:params) {{ :manage_service => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
      end
    end
  end # manage_service =>

  context 'service_ensure =>' do
    context 'running' do
      let(:params) {{ :service_ensure => 'running' }}

      it do
        should contain_service('bwctl').with({
          :ensure => 'running',
          :enable => true,
        })
      end
    end

    context 'stopped' do
      let(:params) {{ :service_ensure => 'stopped' }}

      it do
        should contain_service('bwctl').with({
          :ensure => 'stopped',
          :enable => true,
        })
      end
    end

    context 'foo' do
      let(:params) {{ :service_ensure => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape("is not 'running' or 'stopped'")}/)
      end
    end
  end # service_ensure =>

  context 'service_enable =>' do
    context 'true' do
      let(:params) {{ :service_enable => true }}

      it do
        should contain_service('bwctl').with({
          :ensure => 'running',
          :enable => true,
        })
      end
    end

    context 'false' do
      let(:params) {{ :service_enable => false }}

      it do
        should contain_service('bwctl').with({
          :ensure => 'running',
          :enable => false,
        })
      end
    end

    context 'foo' do
      let(:params) {{ :service_enable => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
      end
    end
  end # service_enable =>

end
