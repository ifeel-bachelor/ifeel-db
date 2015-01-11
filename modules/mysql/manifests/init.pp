class mysql {

  # root mysql password
  $mysqlpw = "root"

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

  
}
