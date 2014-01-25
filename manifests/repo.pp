class perfsonar::repo {

  wget::fetch { 'RPM-GPG-KEY-Internet2':
    source      => 'http://software.internet2.edu/rpms/RPM-GPG-KEY-Internet2',
    destination => '/etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
    timeout     => 60,
    verbose     => false,
  }

  yumrepo { 'Internet2':
    descr    => 'Internet2 RPM Repository - software.internet2.edu - main',
    baseurl  => 'http://software.internet2.edu/rpms/el6/$basearch/main/',
    enabled  => 1,
    protect  => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
    gpgcheck => 1,
    require  => Wget::Fetch['RPM-GPG-KEY-Internet2'],
  }

  yumrepo { 'Internet2-web100_kernel':
    descr    => 'Internet2 Web100 Kernel RPM Repository - software.internet2.edu - main',
    baseurl  => 'http://software.internet2.edu/web100_kernel/rpms/el6/$basearch/main/',
    enabled  => 0,
    protect  => 0,
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Internet2',
    gpgcheck => 1,
    require  => Wget::Fetch['RPM-GPG-KEY-Internet2'],
  }
}
