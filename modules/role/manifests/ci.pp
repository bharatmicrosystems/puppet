class role::ci {
   class {'profile::jenkinsci':
   }
   class {'profile::docker':
      require => Class['profile::jenkinsci']
   }
   class {'profile::kubernetes':
      require => Class['profile::docker']
   }
}

