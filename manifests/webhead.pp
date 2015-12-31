define wordpress_app::webhead(
  String $host,
  String $port,
  String $user,
  String $pass,
  String $db_name,
  String $apache_port = '8080',
  String $interface = 'undef'
) {

  class {'apache':
    default_vhost => false,
  }
  include apache::mod::php
  include mysql::client
  include mysql::bindings
  include mysql::bindings::php

  apache::vhost { $::fqdn:
    priority   => '10',
    vhost_name => $::fqdn,
    port       => $apache_port,
    docroot    => '/var/www/html',
    ip         => '*',
  } ->

  class {'wordpress':
    db_host        => $host,
    db_name        => $db_name,
    db_user        => $user,
    db_password    => $pass,
    create_db      => false,
    create_db_user => false,
    install_dir    => '/var/www/html',
    require        => Class['Mysql::Client'],
  }

  firewall { "${apache_port} allow apache access":
    dport  => [$apache_port],
    proto  => tcp,
    action => accept,
  }
}
Wordpress_app::Webhead consumes Wordpress_db {}
Wordpress_app::Webhead produces Wordpress_http {
  name => $name,
  ip   => $interface ? { 'undef' => $::ipaddress, default => $::networking['interfaces'][$interface]['ip'] },
  port => $apache_port,
  host => $::hostname,
}
