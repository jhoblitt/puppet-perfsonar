require 'spec_helper'

describe 'perfsonar', :type => :class do
  let(:facts) {{ :concat_basedir => '/dne' }}

  describe 'for osfamily RedHat' do
    context 'defaults' do
      it { should contain_class('perfsonar') }
      it { should contain_class('perfsonar::repo') }
      it { should contain_class('perfsonar::bwctl') }
    end

    context 'manage_repo =>' do
      context 'true' do
        let(:params) {{ :manage_repo => true }}

        it { should contain_class('perfsonar::repo') }
      end

      context 'false' do
        let(:params) {{ :manage_repo => false }}

        it { should_not contain_class('perfsonar::repo') }
      end

      context 'foo' do
        let(:params) {{ :manage_repo => 'foo' }}

        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
        end

      end
    end # manage_repo =>

    context 'enable_bwctl =>' do
      context 'true' do
        let(:params) {{ :enable_bwctl => true }}

        it { should contain_class('perfsonar::bwctl') }
      end

      context 'false' do
        let(:params) {{ :enable_bwctl => false }}

        it { should_not contain_class('perfsonar::bwctl') }
      end

      context 'foo' do
        let(:params) {{ :enable_bwctl => 'foo' }}

        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
        end
      end

      context 'true & manage_repo => true' do
        let(:params) {{ :enable_bwctl => true, :manage_repo => true }}

        it { should contain_class('perfsonar::repo') }
        it { should contain_class('perfsonar::bwctl').that_requires('Class[perfsonar::repo]') }
      end

      context 'true & manage_repo => false' do
        let(:params) {{ :enable_bwctl => true, :manage_repo => false }}

        it { should_not contain_class('perfsonar::repo') }
        it { should contain_class('perfsonar::bwctl') }
      end
    end # enable_bwctl =>

    context 'enable_owamp =>' do
      context 'true' do
        let(:params) {{ :enable_owamp => true }}

        it { should contain_class('perfsonar::owamp') }
      end

      context 'false' do
        let(:params) {{ :enable_owamp => false }}

        it { should_not contain_class('perfsonar::owamp') }
      end

      context 'foo' do
        let(:params) {{ :enable_owamp => 'foo' }}

        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
        end
      end

      context 'true & manage_repo => true' do
        let(:params) {{ :enable_owamp => true, :manage_repo => true }}

        it { should contain_class('perfsonar::repo') }
        it { should contain_class('perfsonar::owamp').that_requires('Class[perfsonar::repo]') }
      end

      context 'true & manage_repo => false' do
        let(:params) {{ :enable_owamp => true, :manage_repo => false }}

        it { should_not contain_class('perfsonar::repo') }
        it { should contain_class('perfsonar::owamp') }
      end
    end # enable_owamp =>
  end

end
