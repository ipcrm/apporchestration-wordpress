define wordpress_app::database(
  String $app_domain,
  String $db_name   = 'wordpress',
  String $db_user   = 'wordpress',
  String $db_pass   = 'wordpress',
  String $db_port   = '3306',
  String $listen_ip = '0.0.0.0'
){

  # Set User Domain
  $mysql_user_domain = $app_domain ? {
    'undef' => '%',
    /\S+/   => "%.${app_domain}",
    default => '%',
  }

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

  mysql_user { "${db_user}@${mysql_user_domain}":
    ensure        => 'present',
    password_hash => mysql_password($db_pass),
  } ->

  mysql_grant { "${db_user}@${mysql_user_domain}/${db_name}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${db_name}.*",
    user       => "${db_user}@${mysql_user_domain}"
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
Wordpress_app::Database produces Wordpress_db {
  host     => $::fqdn,
  port     => $db_port,
  user     => $db_user,
  pass     => $db_pass,
  db_name  => $db_name,
  provider => 'tcp',
}
