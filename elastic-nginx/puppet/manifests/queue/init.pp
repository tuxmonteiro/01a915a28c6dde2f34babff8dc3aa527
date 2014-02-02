stage {'req-install':
    before => Stage['main'],
}

class { 'pre_install':
    stage => 'req-install',
}

class pre_install {

    exec {'update-apt':
        command   => '/usr/bin/apt-get update -y',
        logoutput => true,
        timeout   => 300,
    }

    package {
        ['beanstalkd']:
            ensure  => installed,
            require => Exec['update-apt'],
    }
}
