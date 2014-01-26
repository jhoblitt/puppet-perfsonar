# private class
class perfsonar::bwctl::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $::perfsonar::bwctl::package_name:
    ensure => present,
  }

  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  ensure_packages(any2array($::perfsonar::bwctl::package_dep))
}
