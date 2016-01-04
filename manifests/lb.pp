# See Readme
define wordpress_app::lb (
  $balancermembers,
  Array $lb_options     = ['forwardfor', 'http-server-close', 'httplog'],
  String $ipaddress     = '0.0.0.0',
  String $balance_mode  = 'roundrobin',
  String $port          = '80'
){
  class {'haproxy': }
  haproxy::listen {"wordpress-${name}":
    collect_exported => false,
    ipaddress        => $ipaddress,
    mode             => 'http',
    options          => {
      'cookie'       => 'SERVERID insert indirect',
      'option'       => $lb_options,
      'balance'      => $balance_mode,
    },
    ports            => $port,
  }

  $balancermembers.each |$member| {
    haproxy::balancermember { $member['host']:
      listening_service => "wordpress-${name}",
      server_names      => $member['host'],
      ipaddresses       => $member['ip'],
      ports             => $member['port'],
      options           => "check cookie ${member['host']}",
    }
  }

  firewall { "${port} allow haproxy access":
    dport  => [$port],
    proto  => tcp,
    action => accept,
  }
}
Wordpress_app::Lb produces Wordpress_lb {
  name => $name,
  host => $::hostname,
  ip   => $::ipaddress,
  port => $port,
}
