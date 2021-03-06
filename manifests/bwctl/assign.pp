define perfsonar::bwctl::assign (
  $order           = 10,
  $authtype        = $name,
  $classname       = undef,
) {
  validate_string($authtype)
  validate_string($classname)

  concat::fragment { "bwctld.limits-assign-${name}":
    target   => 'bwctld.limits',
    content  => template("${module_name}/bwctld.limits-assign.erb"),
    order    => $order,
  }
}
