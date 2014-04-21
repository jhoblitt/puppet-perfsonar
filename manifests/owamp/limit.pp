# private type
define perfsonar::owamp::limit (
  $order           = 10,
  $classname       = $name,
  $allow_open_mode = undef,
  $bandwidth       = undef,
  $disk            = undef,
  $delete_on_fetch = undef,
  $parent          = undef,
) {
  validate_string($classname)
  if $allow_open_mode {
    validate_re($allow_open_mode , [ '^on$', '^off$' ], "${allow_open_mode} is not on/off")
  }
  validate_string($bandwidth)
  validate_string($disk)
  if $delete_on_fetch {
    validate_re($delete_on_fetch, [ '^on$', '^off$' ], "${delete_on_fetch} is not on/off")
  }
  validate_string($parent)

  $limit = perfsonar_delete_undef_values({
    allow_open_mode => $allow_open_mode,
    bandwidth       => $bandwidth,
    disk            => $disk,
    delete_on_fetch => $delete_on_fetch,
    parent          => $parent,
  }, undef)

  concat::fragment { "owampd.limits-${name}":
    target   => 'owampd.limits',
    content  => template("${module_name}/bwctld.limits.erb"),
    order    => $order,
  }
}
