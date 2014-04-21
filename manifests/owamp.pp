class perfsonar::owamp (
  $manage_install      = $::perfsonar::params::owamp_manage_install,
  $package_name        = $::perfsonar::params::owamp_package_name,
  $manage_service      = $::perfsonar::params::owamp_manage_service,
  $service_name        = $::perfsonar::params::owamp_service_name,
  $service_ensure      = $::perfsonar::params::owamp_service_ensure,
  $service_enable      = $::perfsonar::params::owamp_service_enable,
  $manage_config       = $::perfsonar::params::owamp_manage_config,
  $config_file_path    = $::perfsonar::params::owamp_config_file_path,
  $config_file_options = $::perfsonar::params::owamp_config_file_options,
  $manage_limits       = $::perfsonar::params::owamp_manage_limits,
) inherits perfsonar::params {
  validate_bool($manage_install)
  if ! (is_string($package_name) or is_array($package_name)) {
    fail("${package_name} is not a string or array")
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
    'user'        => 'owamp',
    'group'       => 'owamp',
    'verbose'     => undef,
    'facility'    => 'local5',
    'loglocation' => undef,
    'vardir'      => '/var/run',
    'datadir'     => '/var/lib/owamp',
    'testports'   => '8760-8960',
    'diskfudge'   => '3.0',
    'dieby'       => '5',
  }

  $config = perfsonar_merge($config_file_defaults, $config_file_options)

  anchor { "${name}::begin": }

  if $manage_install {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::install': } ->
    Anchor["${name}::end"]
  }

  if $manage_config {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::config': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::owamp::install'] ->
      Class['perfsonar::owamp::config']
    }
  }

  if $manage_limits {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::limits': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::owamp::install'] ->
      Class['perfsonar::owamp::limits']
    }
  }

  if $manage_service {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::service': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::owamp::install'] ->
      Class['perfsonar::owamp::service']
    }

    if $manage_config {
      Class['perfsonar::owamp::config'] ->
      Class['perfsonar::owamp::service']
    }

    if $manage_limits {
      Class['perfsonar::owamp::limits'] ->
      Class['perfsonar::owamp::service']
    }
  }

  anchor { "${name}::end": }
}
