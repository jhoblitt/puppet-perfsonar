# private class
class perfsonar::bwctl::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { 'bwctld.conf':
    ensure  => 'file',
    path    => $::perfsonar::bwctl::config_file_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    replace => true,
    content => template("${module_name}/bwctld.conf.erb"),
  }
}
