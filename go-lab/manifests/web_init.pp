package { 
'mysql-client':
  ensure => installed;
'libmysqlclient-dev':
  ensure => installed;
}

file { 'profiled_go.sh':
  ensure => present,
  path => '/etc/profile.d/go.sh',
  mode => '0755',
  owner => 'root',
  group => 'root',
  source => '/tmp/vagrant-puppet/manifests/etc_profiled_go.sh.erb',
}

file { 'etc_hosts':
  ensure => present,
  path => '/etc/hosts',
  mode => '0644',
  owner => 'root',
  group => 'root',
  source => '/tmp/vagrant-puppet/manifests/etc_hosts.erb',
}

file { 'gocodes_path':
  ensure => directory,
  path => '/opt/go/gocodes',
  mode => '0755',
  owner => 'root',
  group => 'root',
  require => Exec[ 'install-go' ],
}

package { 
'git-core':
  ensure => installed;
'wget':
  ensure => installed;
'tar':
  ensure => installed;
'mercurial':
  ensure => installed;
}

exec { 
'download-go':
  command => '/usr/bin/wget https://go.googlecode.com/files/go1.1.linux-amd64.tar.gz -O /opt/go1.1.linux-amd64.tar.gz',
  cwd => '/',
  unless  => '/bin/ls -d /opt/go1.1.linux-amd64.tar.gz > /dev/null 2>&1',
  creates  => '/opt/go1.1.linux-amd64.tar.gz',
  require => Package[ 'wget' ];

'install-go':
  command => '/bin/tar xfvz /opt/go1.1.linux-amd64.tar.gz',
  cwd => '/opt',
  unless  => '/bin/ls -d /opt/go > /dev/null 2>&1',
  creates  => '/opt/go',
  require => [ Package[ 'tar' ], Exec[ 'download-go' ], ];

'install-revel':
  command => '/opt/go/bin/go get github.com/robfig/revel',
  cwd => '/opt',
  environment => [ 'GOROOT=/opt/go', 'GOPATH=/opt/go/gocodes' ],
  path => '/usr/local/bin:/usr/local/sbin:/opt/go/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  require => [ File[ 'gocodes_path' ], Package [ 'mercurial' ] ];

'install-revel-cli':
  command => '/opt/go/bin/go get github.com/robfig/revel/revel',
  cwd => '/opt',
  environment => [ 'GOROOT=/opt/go', 'GOPATH=/opt/go/gocodes' ],
  path => '/usr/local/bin:/usr/local/sbin:/opt/go/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  require => Exec[ 'install-revel' ];
} 
