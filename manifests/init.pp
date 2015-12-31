application wordpress_app (
  $app_domain,
){

  wordpress_app::database { $name:
    app_domain => $app_domain,
    export     => Wordpressdb["wdp-${name}"]
  }

  wordpress_app::webhead { $name:
    consume => Wordpressdb["wdp-${name}"]
  }

  #wordpres_app::lb { $name: }

}
