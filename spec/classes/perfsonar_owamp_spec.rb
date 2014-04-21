require 'spec_helper'

describe 'perfsonar::owamp', :type => :class do
  let(:facts) {{ :concat_basedir => '/dne' }}

  package_list = [ 'owamp', 'owamp-client', 'owamp-server' ]

  shared_examples 'has_packages' do
    package_list.each { |pkg| it { should contain_package(pkg) } }
  end

  shared_examples 'has_not_packages' do
    package_list.each { |pkg| it { should_not contain_package(pkg) } }
  end

  context 'param defaults' do
    it_behaves_like 'has_packages'
    it do
      should contain_service('owamp').with({
        :ensure => 'running',
        :name   => 'owampd',
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

  context 'manage_service =>' do
    context 'true' do
      let(:params) {{ :manage_service => true }}

      it { should contain_service('owamp') }
    end

    context 'false' do
      let(:params) {{ :manage_service => false }}

      it { should_not contain_service('owamp') }
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
      #  it { should contain_service('owamp').that_requires("Package[#{pkg}]") }
      #end
      # XXX resorting to testing the relationships between private classes
      it { should contain_class('perfsonar::owamp::install').that_comes_before('Class[perfsonar::owamp::service]') }
      it { should contain_class('perfsonar::owamp::service').that_requires('Class[perfsonar::owamp::install]') }
    end

    context 'true & manage_install => false' do
      let(:params) {{ :manage_service => true, :manage_install => false }}

      # XXX resorting to testing the relationships between private classes 
      it { should_not contain_class('perfsonar::owamp::install') }
      it { should contain_class('perfsonar::owamp::service') }
    end
  end # manage_service =>

  context 'service_name =>' do
    context 'foo' do
      let(:params) {{ :service_name => 'foo' }}

      it do
        should contain_service('owamp').with({
          :name   => 'foo',
          :ensure => 'running',
          :enable => true,
        })
      end
    end

    context 'true' do
      let(:params) {{ :service_name => true }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape("is not a string")}/)
      end
    end
  end # service_name =>

  context 'service_ensure =>' do
    context 'running' do
      let(:params) {{ :service_ensure => 'running' }}

      it do
        should contain_service('owamp').with({
          :ensure => 'running',
          :enable => true,
        })
      end
    end

    context 'stopped' do
      let(:params) {{ :service_ensure => 'stopped' }}

      it do
        should contain_service('owamp').with({
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
        should contain_service('owamp').with({
          :ensure => 'running',
          :enable => true,
        })
      end
    end

    context 'false' do
      let(:params) {{ :service_enable => false }}

      it do
        should contain_service('owamp').with({
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

  context 'manage_config =>' do
    context 'true' do
      let(:params) {{ :manage_config => true }}

      it do
        should contain_file('owampd.conf').with({
          :ensure  => 'file',
          :path    => '/etc/owampd/owampd.conf',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0755',
          :replace => true,
        })
      end
    end

    context 'false' do
      let(:params) {{ :manage_config => false }}

      it { should_not contain_file('owampd.conf') }
    end

    context 'foo' do
      let(:params) {{ :manage_config => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
      end
    end
  end # manage_config =>

  context 'config_file_path =>' do
    context '/dne' do
      let(:params) {{ :config_file_path => '/dne' }}

      it do
        should contain_file('owampd.conf').with({
          :ensure  => 'file',
          :path    => '/dne',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0755',
          :replace => true,
        })
      end
    end

    context '../dne' do
      let(:params) {{ :config_file_path => '../dne' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not an absolute path')}/)
      end
    end
  end # config_file_path =>

  context 'config_file_options =>' do
    context '{}' do
      let(:params) {{ :config_file_options => {} }}

      it do
        should contain_file('owampd.conf').with_content(<<-EOS.gsub(/^\s+/, ''))
          # This file is managed by Puppet. DO NOT EDIT.
          datadir                /var/lib/owamp
          dieby                  5
          diskfudge              3.0
          facility               local5
          group                  owamp
          loglocation
          testports              8760-8960
          user                   owamp
          vardir                 /var/run
          verbose
        EOS
      end
    end

    context '{ allow_unsync => undef }' do
      let(:params) {{ :config_file_options => { 'allow_unsync' => nil } }}

      it 'should add a new key' do
        pending('rational ruby <-> DSL handling of nested hash values')
        should contain_file('owampd.conf').with_content(<<-EOS.gsub(/^\s+/, ''))
          # This file is managed by Puppet. DO NOT EDIT.
          allow_unsync
          datadir                /var/lib/owamp
          dieby                  5
          diskfudge              3.0
          facility               local5
          group                  owamp
          loglocation
          testports              8760-8960
          user                   owamp
          vardir                 /var/run
          verbose
        EOS
      end
    end

    context '{ user => nobody }' do
      let(:params) {{ :config_file_options => { 'user' => 'nobody' } }}

      it 'should replace a default key value' do
        should contain_file('owampd.conf').with_content(<<-EOS.gsub(/^\s+/, ''))
          # This file is managed by Puppet. DO NOT EDIT.
          datadir                /var/lib/owamp
          dieby                  5
          diskfudge              3.0
          facility               local5
          group                  owamp
          loglocation
          testports              8760-8960
          user                   nobody
          vardir                 /var/run
          verbose
        EOS
      end
    end

    context 'foo' do
      let(:params) {{ :config_file_options => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a Hash')}/)
      end
    end
  end # config_file_options =>

  context 'manage_limits =>' do
    context 'true' do
      let(:params) {{ :manage_limits => true }}

      it do
        should contain_concat('owampd.limits').with({
          :path  => '/etc/owampd/owampd.limits',
          :owner => 'root',
          :group => 'root',
          :mode  => '0755',
          :warn  => true,
        })
      end
    end

    context 'false' do
      let(:params) {{ :manage_limits => false }}

      it { should_not contain_concat('owampd.limits') }
    end

    context 'foo' do
      let(:params) {{ :manage_limits => 'foo' }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
      end
    end
  end # manage_limits =>

end
