# private type
define perfsonar::bwctl::limit (
  $order           = 10,
  $classname       = $name,
  $allow_open_mode = undef,
  $allow_tcp       = undef,
  $allow_udp       = undef,
  $bandwidth       = undef,
  $duration        = undef,
  $event_horizon   = undef,
  $max_time_error  = undef,
  $parent          = undef,
  $pending         = undef,
) {
  validate_string($classname)
  validate_re($allow_open_mode , [ '^on$', '^off$' ], "${allow_open_mode} is not on/off")
  validate_re($allow_tcp, [ '^on$', '^off$' ], "${allow_tcp} is not on/off")
  validate_re($allow_udp, [ '^on$', '^off$' ], "${allow_udp} is not on/off")
  validate_string($bandwidth)
  validate_string($duration)
  validate_string($event_horizon)
  validate_string($max_time_error)
  validate_string($parent)
  validate_string($pending)

  $limit = perfsonar_delete_undef_values({
    allow_open_mode => $allow_open_mode,
    allow_tcp       => $allow_tcp,
    allow_udp       => $allow_udp,
    bandwidth       => $bandwidth,
    duration        => $duration,
    event_horizon   => $event_horizon,
    max_time_error  => $max_time_error,
    parent          => $parent,
    pending         => $pending,
  }, undef)

  concat::fragment { "limit-${name}":
    target   => 'bwctld.limits',
    content  => template("${module_name}/bwctld.limits.erb"),
    order    => $order,
  }
}
