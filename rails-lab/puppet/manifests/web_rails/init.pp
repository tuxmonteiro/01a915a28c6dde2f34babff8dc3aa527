$projeto      = 'projeto'
$ruby_version = '2.0.0-p247'
$ruby_gemset  = $::projeto
$usuario      = 'vagrant'
$grupo        = 'vagrant'

stage {'req-install':
    before => Stage['rvm-install'],
}

#
class pre_install_rvm {

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

#
class install_rvm {

    class { 'rvm':
        version => 'stable',
        require => Exec['update-apt'],
    }

    rvm_system_ruby {"ruby-${::ruby_version}":
        ensure      => 'present',
        default_use => true,
        require     => Class['rvm'],
    }

    rvm_gemset {"ruby-${::ruby_version}@${::ruby_gemset}":
        ensure  => present,
        require => Rvm_system_ruby["ruby-${::ruby_version}"],
    }

    file { 'rvmrc':
        ensure  => present,
        path    => '/etc/rvmrc',
        owner   => 'root',
        group   => 'rvm',
        mode    => '0664',
        source  => '/tmp/vagrant-puppet/templates/web_rails/rvmrc.erb',
        require => Class['rvm'],
    }

    rvm::system_user { $::usuario: ; }
}

#
class pre_install_project {

    file { 'etc_hosts':
        ensure => present,
        path   => '/etc/hosts',
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => '/tmp/vagrant-puppet/templates/web_rails/etc_hosts.erb',
    }

    file { 'etc_gemrc':
        ensure => present,
        path   => '/etc/gemrc',
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => '/tmp/vagrant-puppet/templates/web_rails/gemrc.erb',
    }

    file { 'project_base':
        ensure  => 'directory',
        path    => '/opt/rails',
        mode    => '0775',
        owner   => $::usuario,
        group   => $::grupo,
    }

}

#
class pre_install {
    class { 'pre_install_rvm':
        stage => 'req-install',
    }
    include install_rvm
    include pre_install_project
}

include pre_install
