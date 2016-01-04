#See Readme
application wordpress_app (
  String $app_domain      = '',
  String $db_name         = 'wordpress',
  String $db_user         = 'wordpress',
  String $db_pass         = 'wordpress',
  String $db_port         = '3306',
  String $db_listen_ip    = '0.0.0.0',
  String $webhead_int     = '',
  String $webhead_port    = '8080',
  String $lb_listen_ip    = '0.0.0.0',
  String $lb_listen_port  = '80',
  String $lb_balance_mode = 'roundrobin',
  Array  $lb_options      = ['forwardfor','http-server-close','httplog'],
){
  $webcount = count(grep(join_keys_to_values(Wordpress_app[$name]['nodes'], ' '), 'Webhead'))
  $webs = $webcount.map |$i| { Wordpress_http["webhead-${name}-${i}"] }

  wordpress_app::database { $name:
    app_domain => $app_domain,
    db_name    => $db_name,
    db_user    => $db_user,
    db_pass    => $db_pass,
    db_port    => $db_port,
    listen_ip  => $db_listen_ip,
    export     => Wordpress_db["wdp-${name}"]
  }

  $webcount.each |$j| {
    wordpress_app::webhead { "${name}-${j}":
      apache_port => $webhead_port,
      interface   => $webhead_int,
      consume     => Wordpress_db["wdp-${name}"],
      export      => Wordpress_http["webhead-${name}-${j}"]
    }
  }

  wordpress_app::lb { $name:
    balancermembers => $webs,
    lb_options      => $lb_options,
    ipaddress       => $lb_listen_ip,
    port            => $lb_listen_port,
    balance_mode    => $lb_balance_mode,
    require         => $webs,
    export          => Wordpress_lb["wdp-${name}"]
  }
}
