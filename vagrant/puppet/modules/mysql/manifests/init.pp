class mysql {

  package { ['mysql-server']:
    ensure => present;
  }

  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'];
  }

  file { '/etc/mysql/my.cnf':
    source  => 'puppet:///modules/mysql/my.cnf',
    require => Package['mysql-server'],
    notify  => Service['mysql'];
  }

  exec { 'set-mysql-password':
    unless  => 'mysqladmin -uroot -proot status',
    command => "mysqladmin -uroot password root",
    require => Service['mysql'];
  }

  exec { 'load-dynamic-sql':
    command => 'mysql -u root -proot < /vagrant/schema/db.sql',
    require => Exec['set-mysql-password'];
  }
}
