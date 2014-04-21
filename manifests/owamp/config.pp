# private class
class perfsonar::owamp::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { 'owampd.conf':
    ensure  => 'file',
    path    => $::perfsonar::owamp::config_file_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    replace => true,
    content => template("${module_name}/bwctld.conf.erb"),
  }
}
