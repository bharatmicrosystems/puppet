class role::ci {
   include profile::jenkinsci
   include profile::docker
   include profile::kubernetes
}

