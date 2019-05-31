# == Class: mq
#
# Full description of class mq here.
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
#  class { 'mq':
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
class mq {
  if $::osfamily != 'windows' {
   package { 'wget':
     ensure => present,
   }

   package { 'tar':
     ensure => present,
   }
 } 

 
 file { '/tmp/mq':
  ensure => 'directory'
 }
 file { '/tmp/mq/mq.tar.gz':
  source   => 'puppet:///modules/mq/mq.tar.gz',
  ensure   => "present",
  require  => File['/tmp/mq']
 }
 exec { 'untar mq':
  command => 'tar -xvzf /tmp/mq/mq.tar.gz',
  path     => '/usr/bin:/usr/sbin:/bin',
  provider => shell,
  cwd => '/tmp/mq',
  creates => '/tmp/mq/MQServer/mqlicense.sh',
  require => File['/tmp/mq/mq.tar.gz']
 }
 exec { 'accept license':
  command => './mqlicense.sh -accept',
  path     => '/usr/bin:/usr/sbin:/bin',
  provider => shell,
  cwd => '/tmp/mq/MQServer',
  require => Exec['untar mq']
 }
 exec { 'accept license':
  command => 'rpm -ivh MQSeries*',
  path     => '/usr/bin:/usr/sbin:/bin',
  provider => shell,
  cwd => '/tmp/mq/MQServer',
  require => Exec['accept license']
 }
}
