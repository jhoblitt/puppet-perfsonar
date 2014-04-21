# private class
class perfsonar::params {
  $manage_repo  = true
  $enable_bwctl = true
  $enable_owamp = true

  $bwctl_manage_install      = true
  $bwctl_package_name        = [ 'bwctl', 'bwctl-client', 'bwctl-server' ]
  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  $bwctl_package_dep         = [ 'iperf', 'nuttcp' ]
  $bwctl_manage_service      = true
  $bwctl_service_name        = 'bwctld'
  $bwctl_service_ensure      = 'running'
  $bwctl_service_enable      = true
  $bwctl_manage_config       = true
  $bwctl_config_file_path    = '/etc/bwctld/bwctld.conf'
  $bwctl_config_file_options = {}
  $bwctl_manage_limits       = true

  $owamp_manage_install      = true
  $owamp_package_name        = [ 'owamp', 'owamp-client', 'owamp-server' ]
  $owamp_manage_service      = true
  $owamp_service_name        = 'owampd'
  $owamp_service_ensure      = 'running'
  $owamp_service_enable      = true
  $owamp_manage_config       = true
  $owamp_config_file_path    = '/etc/owampd/owampd.conf'
  $owamp_config_file_options = {}
  $owamp_manage_limits       = true
}
