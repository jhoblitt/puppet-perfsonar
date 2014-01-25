require 'spec_helper'

describe 'perfsonar::bwctl', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_package('bwctl') }
    it { should contain_package('bwctl-server') }
    it { should contain_package('bwctl-client') }
    it { should contain_package('iperf') }
    it { should contain_package('nuttcp') }
  end

end
