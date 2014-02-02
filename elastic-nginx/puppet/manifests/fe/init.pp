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
        ['nginx']:
            ensure  => installed,
            require => Exec['update-apt'],
    }

    service {'nginx':
        ensure  => running,
        require => Package['nginx'],
    }

}

include jdk7

jdk7::install7{ 'jdk1.7.0_45':
    version              => "7u45" ,
    fullVersion          => "jdk1.7.0_45",
    alternativesPriority => 18000,
    urandomJavaFix       => false,
    sourcePath           => "/tmp/jdk"
}

class { 'jdk7::urandomfix' :}
