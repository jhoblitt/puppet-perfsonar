# private class
class perfsonar::owamp::limits {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  concat { 'owampd.limits':
    path  => '/etc/owampd/owampd.limits',
    owner => 'root',
    group => 'root',
    mode  => '0755',
    warn  => true,
  }
}
