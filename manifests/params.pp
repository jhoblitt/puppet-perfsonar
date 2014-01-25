class perfsonar::params {
  $bwctl_package_name = [ 'bwctl', 'bwctl-client', 'bwctl-server' ]
  # bwctl-1.4.2-5.el6 has iperf as a dep but not nuttcp
  $bwctl_package_dep  = [ 'iperf', 'nuttcp' ]
}
