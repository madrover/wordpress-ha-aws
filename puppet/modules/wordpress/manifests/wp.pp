class wordpress::wp {

    # Copy the Wordpress bundle to /tmp
    # file { '/tmp/latest.tar.gz':
    #     ensure => present,
    #     source => "puppet:///modules/wordpress/latest.tar.gz"
    # }

    # Copy the Wordpress bundle to /tmp
    wget::fetch { "download Google's index":
        source      => 'http://wordpress.org/latest.tar.gz',
        destination => '/tmp/latest.tar.gz',
        timeout     => 0,
        verbose     => false,
    }
    # Extract the Wordpress bundle
    exec { 'extract':
        cwd => "/tmp",
        command => "tar -xvzf latest.tar.gz",
        require => File['/tmp/latest.tar.gz'],
        path => ['/bin'],
    }

    # Copy to /var/www/
    exec { 'copy':
        command => "cp -r /tmp/wordpress/* /var/www/",
        require => Exec['extract'],
        path => ['/bin'],
    }

    # Generate the wp-config.php file using the template
    # file { '/var/www/wp-config.php':
    #     ensure => present,
    #     require => Exec['copy'],
    #     content => template("wordpress/wp-config.php.erb")
    # }
}