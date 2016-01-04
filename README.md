#### Table of Contents

1. [Overview](#overview)
2. [Examples](#examples)
3. [Applications](#applications)
4. [Defines](#defines)
5. [Limitations](#limitations)
6. [Authors](#authors)

## Overview
Using Application Orchestration to manage mysql, apache/wordpress, and haproxy

## Examples

All-In-One node:
```
wordpress_app { 'dev':
    nodes => {
      Node['servera.example.com']  => [
        Wordpress_app::Database['dev'],
        Wordpress_app::Webhead['dev-0'],
        Wordpress_app::Lb['dev'],
     ],
   }
 }
```

Mutli-Node Deployment with custom interface used for webhosts:
```
wordpress_app { 'multi':
  webhead_int => 'enp0s8',
  nodes => {
    Node['servera.example.com']  => [
      Wordpress_app::Database['multi'],
   ],
    Node['serverb.example.com']  => [
      Wordpress_app::Webhead['multi-0'],
   ],
    Node['serverc.example.com']  => [
      Wordpress_app::Webhead['multi-1'],
   ],
    Node['serverd.example.com']  => [
      Wordpress_app::Lb['multi'],
   ],
  }
}
```

### Applications
#### Application: `wordpress_app`
When declared with default options:

- Installs MySQL database on specified host
  - Creates the wordpress database
  - Creates wordpress user/sets password to wordpress
- Installs Apache on the specified host
  - Creates the application vhost
  - Listens on port 8080
  - Installs wordpress application to /var/www/html
  - Configures the wordpress instance for the DB host
- Installs HAProxy on the specified host
  - Configures a listening service that uses port 80
  - Sets up roundrobin loadbalacning using sticky sessions via injected cookies

#### Parameters within `wordpress_app`:


#### `app_domain`
Sets the domain used by mysql user resources when setting up users or grants.  By default this is set to null, meaning that users will be created as 'user@%' - meaning they can connect from anywhere.

#### `db_name`
The name of the database to create.  Default Value 'wordpress'.

#### `db_user`
The name of the databse user to create.  Utilizes `app_domain` to determine the suffix to give the user.  By default two users are created, 'wordpress'@'localhost' and 'wordpress'@'%'.  The second user will use the value of `app_domain` if provided.  Default Value: 'wordpress'.

#### `db_pass`
Password for the user created by the `db_user` parameter.  Default Value 'wordpress'.

#### `db_port`
Port for the mysql service to listen on.  Default Value '3306'.

#### `db_listen_ip`
IP Address for mysql to listen on.  Default Value '0.0.0.0'.

#### `lb_options`
Global options to be passed to HAProxy.  Default Value: '["forwardfor", "http-server-close", "httplog"]'

#### `lb_listen_ip`
IP Address for HAProxy to listen on.  Default Value: '0.0.0.0'

#### `lb_listen_port`
Port that HAProxy should listen on.  Default Value: '80'

#### `lb_balance_mode`
Load balancing method used for HAProxy.  Default Value: 'roundrobin'

#### `webhead_int`
Sets the interface name to be used when determining the IP address that should be used in the wordpress_http service resource, as well as for the vhost.  Ultimately this is the IP used by HAProxy for the node.  This interface should be global and match accross nodes.

#### `webhead_port`
Sets the listen port for the Apache instances.  Default Value: '8080'


### Defines

This chart provided for reference ONLY, you should only interface with these via the application `wordpress_app`

| Defined Type Name                 | Description                                                              |
| ----------------------------------|--------------------------------------------------------------------------|
| wordpress_app::database | Installs and Configures MySQL, Sets up Wordpress User
| wordpress_app::webhead | Configures Apache, deployes and configures Wordpress
| wordpress_app::lb | Installs and Configures HAProxy

### Limitations 
No tests!  There are no tests setup for verifying this application's manifests.

### Authors
 - [ipcrm](http://github.com/ipcrm)
 - [9bryan](https://github.com/9bryan)
 - [Grace-Andrews](https://github.com/Grace-Andrews)

