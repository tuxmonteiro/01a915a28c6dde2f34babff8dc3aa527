package { 'mysql-server':
	ensure  => installed,
    require => Exec['update-apt'],
}

file { 'etc_mysql_my_cnf':
  ensure => present,
  path   => '/etc/mysql/my.cnf',
  mode   => '0644',
  owner  => 'root',
  group  => 'root',
  source => '/tmp/vagrant-puppet/templates/db_rails/my_cnf.erb',
  notify => Service[ 'mysql' ],
  require => Package[ 'mysql-server' ],
}

service { 'mysql':
  ensure  => running,
  require => Package[ 'mysql-server' ],
}

exec {
'update-apt':
  command => "/usr/bin/apt-get update -y";
'create-admin-db':
  unless  => "/usr/bin/mysql -uadmin -padmin",
  command => "/usr/bin/mysql -uroot -e \"grant all on *.* to admin@'%' identified by 'admin';\"",
  require => Service[ 'mysql' ];
}
