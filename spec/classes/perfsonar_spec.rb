require 'spec_helper'

describe 'perfsonar', :type => :class do

  describe 'for osfamily RedHat' do
    context 'defaults' do
      it { should contain_class('perfsonar') }
      it { should contain_class('perfsonar::repo') }
    end

    context 'manage_repo =>' do
      context 'true' do
        let(:params) {{ :manage_repo => true }}

        it { should contain_class('perfsonar') }
        it { should contain_class('perfsonar::repo') }
      end

      context 'false' do
        let(:params) {{ :manage_repo => false }}

        it { should contain_class('perfsonar') }
        it { should_not contain_class('perfsonar::repo') }
      end

      context 'foo' do
        let(:params) {{ :manage_repo => 'foo' }}

        it 'should fail' do
          expect { should }.to raise_error(Puppet::Error, /#{Regexp.escape('is not a boolean')}/)
        end

      end
    end # manage_repo =>
  end

end
