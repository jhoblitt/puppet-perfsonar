# private class
class perfsonar::bwctl::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'bwctl':
    ensure     => $::perfsonar::bwctl::service_ensure,
    name       => $::perfsonar::bwctl::service_name,
    enable     => $::perfsonar::bwctl::service_enable,
    hasrestart => true,
    hasstatus  => false,
    status     => 'kill -0 `cat /var/run/bwctld.pid`',
  }
}
