package { 'mysql-server':
	ensure => installed,
}

file { 'etc_mysql_my_cnf':
  ensure => present,
  path => '/etc/mysql/my.cnf',
  mode => '0644',
  owner => 'root',
  group => 'root',
  source => '/tmp/vagrant-puppet/manifests/my_cnf.erb',
  notify => Service[ 'mysql' ],
}

service { 'mysql':
  ensure => running,
  require => Package[ 'mysql-server' ],
}

exec { "create-admin-db":
  unless => "/usr/bin/mysql -uadmin -padmin",
  command => "/usr/bin/mysql -uroot -e \"grant all on *.* to admin@'%' identified by 'admin';\"",
  require => Service[ 'mysql' ],
}
