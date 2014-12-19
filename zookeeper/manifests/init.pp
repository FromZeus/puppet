class zookeeper {

  if ($operatingsystem == 'Ubuntu')
  {
    exec { 'apt-update':
      command => '/usr/bin/apt-get update'
    }

    package { 'default-jre':
      require => Exec['apt-update'],
      ensure => installed,
    }

    package { 'zookeeper':
      require => [ Exec['apt-update'], Package['default-jre'] ],
      ensure => installed,
    }

    package { 'zookeeperd':
      require => Package['zookeeper'],
      ensure => installed,
    }

    service { 'zookeeper':
      require => Package['zookeeperd'],
      ensure => running,
    }
  }
  else
  {
    package { 'java-1.6.0-openjdk.x86_64':
      ensure => installed,
    } ->

    zookeeper::zoorpm { 'zoorpm':
      zoo_source => 'ftp://rpmfind.net/linux/fedora/linux/development/rawhide/x86_64/os/Packages/z/zookeeper-3.4.6-2.fc22.x86_64.rpm',
      zoo_name => 'zookeeper-3.4.6',
    }
  }
}
