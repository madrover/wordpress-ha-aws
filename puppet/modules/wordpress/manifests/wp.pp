class wordpress::wp {

    wget::fetch { "download wp-cli":
        source      => 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar',
        destination => '/usr/local/bin/wp',
        timeout     => 0,
        verbose     => false,
        before => File['/usr/local/bin/wp'],
    }
    
    file { '/usr/local/bin/wp':
        mode => '700',
    }

    exec { 'download wordpress':
        cwd => "/var/www/html",
        command => "wp core download --force",
        path => ['/usr/bin:/usr/local/bin'],
        require => File['/usr/local/bin/wp'],
    }

    exec { 'configure wp-config.php':
        cwd => "/var/www/html",
        command => "rm wp-config.php;php /usr/local/bin/wp core config --dbname=${wordpress::conf::db_name} --dbuser=${wordpress::conf::db_user} --dbpass=${wordpress::conf::root_password}",
        path => ['/bin:/usr/bin:/usr/local/bin'],
        require => Exec['download wordpress'],
    }

    exec { 'install wordpress':
        cwd => "/var/www/html",
        command => "php /usr/local/bin/wp core install --url=$ec2_public_hostname --title=WordPress --admin_user=myusername --admin_password=mypassword --admin_email=test@test.com" ,
        path => ['/usr/bin:/usr/local/bin'],
        require => Exec['configure wp-config.php'],
    }
        # Copy the Wordpress bundle to /tmp
    # file { '/tmp/latest.tar.gz':
    #     ensure => present,
    #     source => "puppet:///modules/wordpress/latest.tar.gz"
    # }

    # Copy the Wordpress bundle to /tmp
    # wget::fetch { "download latest wordpress files":
    #     source      => 'http://wordpress.org/latest.tar.gz',
    #     destination => '/tmp/latest.tar.gz',
    #     timeout     => 0,
    #     verbose     => false,
    #     before => Exec['extract'],
    # }
    # Extract the Wordpress bundle
    # exec { 'extract':
    #     cwd => "/var/www/html",
    #     command => "tar -xvzf /tmp/latest.tar.gz",
    #     #require => File['/tmp/latest.tar.gz'],
    #     path => ['/bin'],
    # }

    # Copy to /var/www/
    # exec { 'copy':
    #     command => "cp -r /tmp/wordpress/* /var/www/html",
    #     require => Exec['extract'],
    #     path => ['/bin'],
    # }

    # Generate the wp-config.php file using the template
    # file { '/var/www/wp-config.php':
    #     ensure => present,
    #     require => Exec['copy'],
    #     content => template("wordpress/wp-config.php.erb")
    # }


}