# private class
class perfsonar::params {
  $bwctl_manage_install = true
  $bwctl_package_name   = [ 'bwctl', 'bwctl-client', 'bwctl-server' ]
  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  $bwctl_package_dep    = [ 'iperf', 'nuttcp' ]
  $bwctl_manage_service = true
  $bwctl_service_name   = 'bwctld'
  $bwctl_service_ensure = 'running'
  $bwctl_service_enable = true
}
