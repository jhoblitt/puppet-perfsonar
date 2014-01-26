# private class
class perfsonar::owamp::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'owamp':
    ensure     => $::perfsonar::owamp::service_ensure,
    name       => $::perfsonar::owamp::service_name,
    enable     => $::perfsonar::owamp::service_enable,
    hasrestart => true,
    hasstatus  => false,
    status     => 'kill -0 `cat /var/run/owampd.pid`',
  }
}
