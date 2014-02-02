stage {'pre':
    before => Stage['main'],
}
class { 'pre':
    stage => 'pre',
}
class { 'install':
    stage => 'main',
}

Exec {
    path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin']
}

#
class pre {

  yumrepo {
    'epel':
        descr      => 'Extra Packages for Enterprise Linux 5 - $basearch',
        mirrorlist => 'https://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch',
        enabled    => 1,
        gpgcheck   => 0;
  }

  exec {'update-repocheck':
    command     => '/usr/bin/yum check-update -y',
    logoutput   => true,
    timeout     => 300,
    returns     => [ 0, 100 ],
    refreshonly => true,
    require     => Yumrepo[ 'epel' ],
  }

  File{
    owner   => 'root',
    mode    => '06440',
    require => Exec['update-repocheck'],
  }

}

#
class install {
    exec { 'install_intelligentmirror':
        command   => '/bin/rpm -iv --nogpg /tmp/vagrant-puppet/files/intelligentmirror-1.0.1-1.noarch.rpm',
        logoutput => true,
        timeout   => 300,
        returns   => [ 0, 100 ],
    }
    package {'squid':
        ensure => installed,
    }
    service {'squid':
        ensure  => running,
        require => [Package['squid'], Exec['install_intelligentmirror']],
    }
}

require install
