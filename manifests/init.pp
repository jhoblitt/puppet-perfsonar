# == Class: perfsonar
#
# simple template
#
# === Examples
#
# include perfsonar
#
class perfsonar (
  $manage_repo  = $::perfsonar::params::manage_repo,
  $enable_bwctl = $::perfsonar::params::enable_bwctl,
  $enable_owamp = $::perfsonar::params::enable_owamp,
) inherits perfsonar::params {
  validate_bool($manage_repo)
  validate_bool($enable_bwctl)
  validate_bool($enable_owamp)

  if $manage_repo {
    include perfsonar::repo
  }

  if $enable_bwctl {
    include perfsonar::bwctl

    if $manage_repo {
      Class['perfsonar::repo'] -> Class['perfsonar::bwctl']
    }
  }

  if $enable_owamp {
    include perfsonar::owamp

    if $manage_repo {
      Class['perfsonar::repo'] -> Class['perfsonar::owamp']
    }
  }
}
