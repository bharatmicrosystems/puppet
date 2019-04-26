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
class dockerce {
  package{ 'yum-utils':
    ensure => installed
  }
  package{ 'device-mapper-persistent-data':
    ensure => installed,
    require => Package['yum-utils']
  }
  package{ 'lvm2':
    ensure => installed,
    require => Package['device-mapper-persistent-data']
  }
  exec{ 'container-selinux':
    command => 'yum -y install http://vault.centos.org/centos/7.3.1611/extras/x86_64/Packages/container-selinux-2.9-4.el7.noarch.rpm',
    path => ['/usr/bin', '/usr/sbin'],
    creates => '/usr/share/selinux/packages/container.pp.bz2',
    require => Package['lvm2']
  }
  exec{ 'yum-config-manager':
    command => "yum-config-manager  --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
    path => ['/usr/bin', '/usr/sbin'],
    require => Exec['container-selinux']
  }
  exec { 'import_gpg_key':
     command => 'rpm --import https://download.docker.com/linux/centos/gpg',
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => Exec['yum-config-manager']
  }
  package{ 'docker-ce':
    ensure => installed,
    require => Exec['yum-config-manager']
  }
  package{ 'docker-ce-cli':
    ensure => installed,
    require => Package['docker-ce']
  }
  package{ 'containerd.io':
    ensure => installed,
    require => Package['docker-ce-cli']
  }
  service{ 'docker':
    ensure => running,
    enable => true,
    require => Package['containerd.io']
  }
  exec{ 'docker-compose':
     command => 'curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose',
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     creates => '/usr/local/bin/docker-compose',
     require => Service['docker']
  }
  file{ '/usr/local/bin/docker-compose':
     ensure => present,
     mode => '755',
     require => Exec['docker-compose']
  }
}
