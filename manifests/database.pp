define wordpress_app::database(
  $app_domain,
  $db_name   = 'wordpress',
  $db_user   = 'wordpress',
  $db_pass   = 'wordpress',
  $db_port   = '3306',
  $listen_ip = '0.0.0.0'
){

  class { 'mysql::server':
     override_options => {
       'mysqld'       => {
         'bind_address' => $listen_ip,
         'port'         => $db_port,
       },
     },
  } ->

  mysql_database { $db_name:
    name => $db_name,
    charset => 'utf8',
  } ->

  mysql_user { "${db_user}@%.${app_domain}":
    ensure        => 'present',
    password_hash => mysql_password($db_pass),
  } ->

  mysql_grant { "${db_user}@%.${app_domain}/${db_name}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${db_name}.*",
    user       => "${db_user}@%.${app_domain}"
  }

  mysql_user { "${db_user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($db_pass),
  } ->

  mysql_grant { "${db_user}@localhost/${db_name}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${db_name}.*",
    user       => "${db_user}@localhost"
  }

  firewall { "${db_port} allow apache access":
    dport  => [$db_port],
    proto  => tcp,
    action => accept,
  }

}
Wordpress_app::Database produces Wordpressdb {
  host     => $::fqdn,
  port     => $db_port,
  user     => $db_user,
  pass     => $db_pass,
  db_name  => $db_name,
  provider => 'tcp',
}
