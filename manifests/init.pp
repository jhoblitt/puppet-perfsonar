# == Class: perfsonar
#
# simple template
#
# === Examples
#
# include perfsonar
#
class perfsonar (
  $manage_repo  = true,
  $enable_bwctl = true,
) {
  validate_bool($manage_repo)
  validate_bool($enable_bwctl)

  if $manage_repo {
    include perfsonar::repo
  }

  if $enable_bwctl {
    include perfsonar::bwctl

    if $manage_repo {
      Class['perfsonar::repo'] -> Class['perfsonar::bwctl']
    }
  }
}
