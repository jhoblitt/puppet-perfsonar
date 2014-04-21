class perfsonar::bwctl (
  $manage_install      = $::perfsonar::params::bwctl_manage_install,
  $package_name        = $::perfsonar::params::bwctl_package_name,
  $package_dep         = $::perfsonar::params::bwctl_package_dep,
  $manage_service      = $::perfsonar::params::bwctl_manage_service,
  $service_name        = $::perfsonar::params::bwctl_service_name,
  $service_ensure      = $::perfsonar::params::bwctl_service_ensure,
  $service_enable      = $::perfsonar::params::bwctl_service_enable,
  $manage_config       = $::perfsonar::params::bwctl_manage_config,
  $config_file_path    = $::perfsonar::params::bwctl_config_file_path,
  $config_file_options = $::perfsonar::params::bwctl_config_file_options,
  $manage_limits       = $::perfsonar::params::bwctl_manage_limits,
) inherits perfsonar::params {
  validate_bool($manage_install)
  if ! (is_string($package_name) or is_array($package_name)) {
    fail("${package_name} is not a string or array")
  }
  if ! (is_string($package_dep) or is_array($package_dep)) {
    fail("${package_dep} is not a string or array")
  }
  validate_bool($manage_service)
  validate_string($service_name)
  validate_re($service_ensure, [ '^running$', '^stopped$' ],
    "${service_ensure} is not 'running' or 'stopped'")
  validate_bool($service_enable)
  validate_bool($manage_config)
  validate_absolute_path($config_file_path)
  validate_hash($config_file_options)
  validate_bool($manage_limits)

  $config_file_defaults = {
    'iperf_port'   => '5001-5300',
    'nuttcp_port'  => '5301-5600',
    'peer_port'    => '6001-6200',
    'user'         => 'bwctl',
    'group'        => 'bwctl',
    'log_location' => undef,
  }

  $config = perfsonar_merge($config_file_defaults, $config_file_options)

  anchor { "${name}::begin": }

  if $manage_install {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::install': } ->
    Anchor["${name}::end"]
  }

  if $manage_config {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::config': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::bwctl::install'] ->
      Class['perfsonar::bwctl::config']
    }
  }

  if $manage_limits {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::limits': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::bwctl::install'] ->
      Class['perfsonar::bwctl::limits']
    }
  }

  if $manage_service {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::service': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::bwctl::install'] ->
      Class['perfsonar::bwctl::service']
    }

    if $manage_config {
      Class['perfsonar::bwctl::config'] ->
      Class['perfsonar::bwctl::service']
    }

    if $manage_limits {
      Class['perfsonar::bwctl::limits'] ->
      Class['perfsonar::bwctl::service']
    }
  }

  anchor { "${name}::end": }
}
