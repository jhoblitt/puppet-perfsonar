require 'spec_helper'

describe 'perfsonar::bwctl', :type => :class do
  package_list = [
    'bwctl', 'bwctl-client', 'bwctl-server',
    'iperf', 'nuttcp',
  ]

  shared_examples 'has_packages' do
    package_list.each { |pkg| it { should contain_package(pkg) } }
  end

  shared_examples 'has_not_packages' do
    package_list.each { |pkg| it { should_not contain_package(pkg) } }
  end

  context 'param defaults' do
    it_behaves_like 'has_packages'
    it do
      should contain_service('bwctl').with({
        :ensure => 'running',
        :enable => true,
      })
    end
  end # param defaults

  context 'manage_install =>' do
    context 'true' do
      let(:params) {{ :manage_install => true }}

      it_behaves_like 'has_packages'
    end

    context 'false' do
      let(:params) {{ :manage_install => false }}

      it_behaves_like 'has_not_packages'
    end

    context 'foo' do
      let(:params) {{ :manage_install => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
      end
    end
  end # manage_install =>

  context 'package_name =>' do
    context 'foo' do
      let(:params) {{ :package_name => 'foo' }}

      it { should contain_package('foo') }
    end

    context '[foo, bar]' do
      let(:params) {{ :package_name => %w{foo bar} }}

      it { should contain_package('foo') }
      it { should contain_package('bar') }
    end

    context 'true' do
      let(:params) {{ :package_name => true }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a string or array')}/)
      end
    end
  end # package_name =>

  context 'package_dep =>' do
    context 'foo' do
      let(:params) {{ :package_dep => 'foo' }}

      it { should contain_package('foo') }
    end

    context '[foo, bar]' do
      let(:params) {{ :package_dep => %w{foo bar} }}

      it { should contain_package('foo') }
      it { should contain_package('bar') }
    end

    context 'true' do
      let(:params) {{ :package_dep => true }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a string or array')}/)
      end
    end
  end # package_dep =>

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

    context 'true & manage_install => true' do
      let(:params) {{ :manage_service => true, :manage_install => true }}

      # XXX rspec-puppet 1.0.1 doesn't seem to be able to test deps between
      # resources across class boundaries
      #package_list.each do |pkg|
      #  it { should contain_service('bwctl').that_requires("Package[#{pkg}]") }
      #end
      # XXX resorting to testing the relationships between private classes
      it { should contain_class('perfsonar::bwctl::install').that_comes_before('Class[perfsonar::bwctl::service]') }
      it { should contain_class('perfsonar::bwctl::service').that_requires('Class[perfsonar::bwctl::install]') }
    end

    context 'true & manage_install => false' do
      let(:params) {{ :manage_service => true, :manage_install => false }}

      # XXX resorting to testing the relationships between private classes 
      it { should_not contain_class('perfsonar::bwctl::install') }
      it { should contain_class('perfsonar::bwctl::service') }
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
