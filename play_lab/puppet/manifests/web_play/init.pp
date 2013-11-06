class pre_install_play {

    exec {'update-apt':
        command   => '/usr/bin/apt-get update -y',
        logoutput => true,
        timeout   => 300,
    }

    package {
        ['mysql-client', 'libmysqlclient-dev', 'nginx']:
            ensure  => installed,
            require => Exec['update-apt'],
    }
}

class {'play':
    version => "2.2.1",
    user    => 'vagrant',
    require => [ Jdk7::Install7['jdk1.7.0_45'], Class['pre_install_play'], ]
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
