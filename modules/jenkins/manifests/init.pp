class jenkins {
   package { 'wget':
     ensure => installed
   }
   exec { 'jenkins_repo':
     command => 'wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo',
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     creates => '/etc/yum.repos.d/jenkins.repo',
     require => Package['wget']
   }
   exec { 'import_jenkins_key':
     command => 'rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key',
     path     => '/usr/bin:/usr/sbin:/bin',
     provider => shell,
     require => Exec['jenkins_repo']
   }
   package {'jenkins':
     ensure => installed,
     require => Exec['import_jenkins_key']
   }
   service {'jenkins':
     ensure => stopped,
     enable => false,
     require => Package['jenkins']
   }
}
