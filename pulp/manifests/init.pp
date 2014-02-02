stage {'pre':
    before => Stage['main'],
}
class { 'pre':
    stage => 'pre',
}
class { 'install':
    stage => 'main',
}

#
class pre {

  yumrepo {
    'pulp-v2-stable':
        descr      => 'Pulp v2 Production Releases',
        baseurl    => 'http://repos.fedorapeople.org/repos/pulp/pulp/stable/2/$releasever/$basearch/',
        enabled    => 1,
        gpgcheck   => 0;
    'epel':
        descr      => 'Extra Packages for Enterprise Linux 6 - $basearch',
        mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
        enabled    => 1,
        gpgcheck   => 0;
  }

  exec {'update-repocheck':
    command     => '/usr/bin/yum check-update -y',
    logoutput   => true,
    timeout     => 300,
    returns     => [ 0, 100 ],
    refreshonly => true,
    require     => Yumrepo[ 'pulp-v2-stable','epel' ],
  }

}

#
class install {
  exec {
  'pulp-server':
    command     => '/usr/bin/yum groupinstall pulp-server -y',
    logoutput   => true,
    timeout     => 300,
    returns     => [ 0, 100 ];
  'pulp-admin':
    command     => '/usr/bin/yum groupinstall pulp-admin -y',
    logoutput   => true,
    timeout     => 300,
    returns     => [ 0, 100 ];
  }

  service {['mongod','qpidd']:
    ensure  => running,
    require => Exec['pulp-server','pulp-admin'],
  }
}

require install
