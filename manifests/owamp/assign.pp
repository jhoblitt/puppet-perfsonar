define perfsonar::owamp::assign (
  $order           = 10,
  $authtype        = $name,
  $classname       = undef,
) {
  validate_string($authtype)
  validate_string($classname)

  concat::fragment { "owampd.limits-assign-${name}":
    target   => 'owampd.limits',
    content  => template("${module_name}/bwctld.limits-assign.erb"),
    order    => $order,
  }
}
