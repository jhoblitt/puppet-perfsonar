class perfsonar::bwctl (
  $manage_service = true,
  $service_ensure = 'running',
  $service_enable = true,
) {
  validate_bool($manage_service)
  validate_re($service_ensure, [ '^running$', '^stopped$' ],
    "${service_ensure} is not 'running' or 'stopped'")
  validate_bool($service_enable)

  include perfsonar::params

  package { $::perfsonar::params::bwctl_package_name:
    ensure => present,
  }

  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  ensure_packages(any2array($::perfsonar::params::bwctl_package_dep))

  if $manage_service {
    class { 'perfsonar::bwctl::service':
      require => Package[$::perfsonar::params::bwctl_package_name],
    }
  }
}
