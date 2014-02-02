#
class myvagrant::so_requisits {

    $cmd = $::operatingsystem ? {
        /(?i)(centos|redhat)/ => '/usr/bin/yum check-update -y',
        /(?i)(debian|ubuntu)/ => '/usr/bin/apt-get update -y',
        default => undef,
    }

    exec {'update-repoinstall':
        command   => $cmd,
        logoutput => true,
        timeout   => 300,
        returns   => [ 0, 100 ]
    }
}

#EOF
