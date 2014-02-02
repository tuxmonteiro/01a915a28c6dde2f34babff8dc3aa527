#
class myvagrant::mysql {

    $mysqlclient = $::operatingsystem ? {
        /(?i)(centos|redhat)/ => 'mysql',
        /(?i)(debian|ubuntu)/ => 'mysql-client',
        default => undef,
    }

    $mysqlclientdev = $::operatingsystem ? {
        /(?i)(centos|redhat)/ => 'mysql-devel',
        /(?i)(debian|ubuntu)/ => 'libmysqlclient-dev',
        default => undef,
    }

    package {'mysqlclient':
        ensure  => installed,
        name    => $mysqlclient,
    }

    package {'mysqlclientdev':
        ensure  => installed,
        name    => $mysqlclientdev,
    }
}

#EOF
