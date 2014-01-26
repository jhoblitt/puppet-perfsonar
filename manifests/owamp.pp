class perfsonar::owamp (
  $manage_install = $::perfsonar::params::owamp_manage_install,
  $package_name   = $::perfsonar::params::owamp_package_name,
  $manage_service = $::perfsonar::params::owamp_manage_service,
  $service_name   = $::perfsonar::params::owamp_service_name,
  $service_ensure = $::perfsonar::params::owamp_service_ensure,
  $service_enable = $::perfsonar::params::owamp_service_enable,
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

  anchor { "${name}::begin": }

  if $manage_install {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::install': } ->
    Anchor["${name}::end"]
  }

  if $manage_service {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::owamp::service': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::owamp::install'] ->
      Class['perfsonar::owamp::service']
    }
  }

  anchor { "${name}::end": }
}
