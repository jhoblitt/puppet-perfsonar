class perfsonar::bwctl {
  include perfsonar::params

  package { $::perfsonar::params::bwctl_package_name:
    ensure => present,
  }

  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  ensure_packages(any2array($::perfsonar::params::bwctl_package_dep))
}
