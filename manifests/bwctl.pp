class perfsonar::bwctl (
  $manage_install = $::perfsonar::params::bwctl_manage_install,
  $package_name   = $::perfsonar::params::bwctl_package_name,
  $package_dep    = $::perfsonar::params::bwctl_package_dep,
  $manage_service = $::perfsonar::params::bwctl_manage_service,
  $service_ensure = $::perfsonar::params::bwctl_service_ensure,
  $service_enable = $::perfsonar::params::bwctl_service_enable,
) inherits perfsonar::params {
  validate_bool($manage_install)
  if ! (is_string($package_name) or is_array($package_name)) {
    fail("${package_name} is not a string or array")
  }
  if ! (is_string($package_dep) or is_array($package_dep)) {
    fail("${package_dep} is not a string or array")
  }
  validate_bool($manage_service)
  validate_re($service_ensure, [ '^running$', '^stopped$' ],
    "${service_ensure} is not 'running' or 'stopped'")
  validate_bool($service_enable)

  anchor { "${name}::begin": }

  if $manage_install {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::install': } ->
    Anchor["${name}::end"]
  }

  if $manage_service {
    Anchor["${name}::begin"] ->
    class { 'perfsonar::bwctl::service': } ->
    Anchor["${name}::end"]

    if $manage_install {
      Class['perfsonar::bwctl::install'] ->
      Class['perfsonar::bwctl::service']
    }
  }

  anchor { "${name}::end": }
}
