stage {'req-install':
    before => Stage['main'],
}

class { 'pre_install':
    stage => 'req-install',
}

class pre_install {

    exec {
    'update-apt':
        command   => '/usr/bin/apt-get update -y',
        logoutput => true,
        timeout   => 300,
        require   => Exec ['atualiza chaveiro'];
    'atualiza chaveiro':
        command => '/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
        logoutput => true,
        timeout   => 300,
        require   => File ['sources.list'];
    }

    file {'sources.list':
        ensure  => present,
        path    => '/etc/apt/sources.list.d/mongodb.list',
        content => 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    package { 'mongodb-10gen':
        ensure  => installed,
        require => Exec['update-apt'],
    }

    service {'mongodb':
        ensure => 'running',
        require => Package['mongodb-10gen'],
    }
}


