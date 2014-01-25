# == Class: perfsonar
#
# simple template
#
# === Examples
#
# include perfsonar
#
class perfsonar (
  $manage_repo = true,
) {
  validate_bool($manage_repo)

  if $manage_repo {
    include perfsonar::repo
  }
}
