# == Class: dockerce
#
# Full description of class dockerce here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'dockerce':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2019 Your name here, unless otherwise noted.
#
class kube {
  file{ '/etc/yum.repos.d/kubernetes.repo':
    ensure => file,
    source => 'puppet:///modules/profile/kubernetes.repo'
  }
  package{ 'kubelet':
    ensure => installed,
    require => File['/etc/yum.repos.d/kubernetes.repo']
  }
  package{ 'kubeadm':
    ensure => installed,
    require => Package['kubelet']
  }
  package{ 'kubectl':
    ensure => installed,
    require => Package['kubeadm']
  }
  service{ 'kubelet':
    ensure => running,
    enable => true,
    require => Package['kubectl']
  }
  exec{ 'setenforce':
     command => 'setenforce 0',
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => Package['kubelet']
  }
  exec{ 'selinuxdisable':
     command => "sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux",
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => Exec['setenforce']
  }
  service{ 'firewalld':
     ensure => stopped,
     enable => false,
     require => Exec['selinuxdisable']
  }
  exec{ 'swapdisable':
     command => "sed -i '/swap/d' /etc/fstab & swapoff -a",
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => Service['firewalld']
  }
  file{ '/etc/sysctl.d/kubernetes.conf':
    ensure => file,
    source => 'puppet:///modules/profile/kubernetes.conf',
    require => Exec['swapdisable']
  }
  exec{'sysctl':
     command => "sysctl --system",
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => File['/etc/sysctl.d/kubernetes.conf']
  }

}
