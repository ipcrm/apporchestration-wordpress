define wordpress_app::webhead(
  $host,
  $port,
  $user,
  $pass,
  $db_name,
  $apache_port = '8080',
) {

  include apache
  include apache::mod::php
  include mysql::bindings
  include mysql::bindings::php

  apache::vhost { $::fqdn:
    priority   => '10',
    vhost_name => $::fqdn,
    port       => $apache_port,
    docroot    => '/var/www/html',
  } ->

  class {'wordpress':
    db_host         => $host,
    db_name         => $db_name,
    db_user         => $user,
    db_password     => $pass,
    create_db       => false,
    install_dir     => '/var/www/html'
#    install_dir          => $install_dir_real,
#    install_url          => 'http://wordpress.org',
#    version              => '4.3.1',
#    wp_owner             => 'root',
#    wp_group             => '0',
#    wp_lang              => '',
#    wp_config_content    => undef,
#    wp_plugin_dir        => 'DEFAULT',
#    wp_additional_config => 'DEFAULT',
#    wp_table_prefix      => 'wp_',
#    wp_proxy_host        => '',
#    wp_proxy_port        => '',
#    wp_multisite         => false,
#    wp_site_domain       => '',
#    wp_debug             => false,
#    wp_debug_log         => false,
#    wp_debug_display     => false,
#    notify               => Service['httpd'],
  }

  firewall { '80 allow apache access':
      dport  => [80],
      proto  => tcp,
      action => accept,
  }
}
Wordpress_app::Webhead consumes Wordpressdb {}
