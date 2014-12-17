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

    file { 'zookeeper_bash':
      ensure => 'file',
      source => 'puppet:///modules/zookeeper/zookeeper.sh',
      path => '/usr/local/bin/zookeeper.sh',
      owner => root,
      group => root,
      mode => '0755',
      notify => Exec['install_zookeeper'],
    } ->

    exec { 'install_zookeeper':
      #require => Package['java-1.6.0-openjdk.x86_64'],
      command => '/usr/local/bin/zookeeper.sh',
      refreshonly => true,
    }
  }
}
