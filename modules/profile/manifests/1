class profile::lamp {
   include mysql::server
   include apache
   include apache::mod::php
   create_resources('mysql::db', hiera('mysql::db', {}))
   create_resources('apache::vhost', hiera('apache::vhost', {}))
}
