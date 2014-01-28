# private class
class perfsonar::bwctl::limits {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  concat { 'bwctld.limits':
    path  => '/etc/bwctld/bwctld.limits',
    owner => 'root',
    group => 'root',
    mode  => '0755',
    warn  => true,
  }
}
