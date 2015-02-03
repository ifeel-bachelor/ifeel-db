class mysql {

  # root mysql password
  $mysqlpw = "root"

  # database name for backend
  $backenddb = "ifeel_backend"

  # install mysql server
  package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"]
  }

  #start mysql service
  service { "mysql":
    ensure => running,
    require => Package["mysql-server"],
  }

  # set mysql password
  exec { "set-mysql-password":
    command => "mysqladmin -uroot password $mysqlpw",
    require => Service["mysql"],
  }

  # set correct mysql bind address
  exec { "mysql-change-bind-address":
    command => "sudo sed -i 's/bind-address.*/bind-address=0.0.0.0/' /etc/mysql/my.cnf && sudo service mysql restart",
    require => Service["mysql"],
    subscribe => Package["mysql-server"],
  }

  # execute SQL for allowing external connection
  exec { "mysql-allow-external":
    command => "mysql -uroot -e \"grant all on *.* to 'root'@'%' identified by '$mysqlpw';\"",
    require => Service["mysql"],
    subscribe => Package["mysql-server"],
  }

  # execute SQL for creating backend database
  exec { "mysql-create-backend-database":
    command => "mysql -uroot -e \"create database if not exists $backenddb default character set utf8 default collate utf8_general_ci;\"",
    require => Service["mysql"],
    subscribe => Package["mysql-server"],
  }
  
}
