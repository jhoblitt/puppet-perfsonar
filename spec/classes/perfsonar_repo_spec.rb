require 'spec_helper'

describe 'perfsonar::repo', :type => :class do

  describe 'for osfamily RedHat' do
    it do
      should contain_yumrepo('Internet2').with({
        :enabled  => 1,
        :protect  => 0,
        :gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
        :gpgcheck => 1,
        :require  => 'Wget::Fetch[RPM-GPG-KEY-Internet2]',
      })
    end
    it do
      should contain_yumrepo('Internet2-web100_kernel').with({
        :enabled  => 1,
        :protect  => 0,
        :gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
        :gpgcheck => 1,
        :require  => 'Wget::Fetch[RPM-GPG-KEY-Internet2]',
      })
    end
    it do
      should contain_wget__fetch('RPM-GPG-KEY-Internet2').with({
        :source      => 'http://software.internet2.edu/rpms/RPM-GPG-KEY-Internet2',
        :destination => '/etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
      })
    end
  end

end
