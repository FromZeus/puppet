define zookeeper::zoorpm(
    $zoo_source = 'ftp://rpmfind.net/linux/fedora/linux/development/rawhide/x86_64/os/Packages/z/zookeeper-3.4.6-2.fc22.x86_64.rpm',
    $zoo_name = 'zookeeper-3.4.6',
    $cs_name = 'checkstyle-5.8',
    $cs_source = 'ftp://rpmfind.net/linux/fedora/linux/development/rawhide/x86_64/os/Packages/c/checkstyle-5.8-1.fc22.noarch.rpm',
    $jl_name = 'jline1-1.0',
    $jl_source = 'ftp://rpmfind.net/linux/fedora/linux/releases/21/Everything/x86_64/os/Packages/j/jline1-1.0-10.fc21.noarch.rpm',
    $jt_name = 'jtoaster-1.0.5',
    $jt_source = 'ftp://ftp.pbone.net/mirror/distrib-coffee.ipsl.jussieu.fr/mageia/distrib/cauldron/x86_64/media/core/release/jtoaster-1.0.5-4.mga5.noarch.rpm',
    $ju_name = 'junit-4.11',
    $ju_source = 'ftp://mirror.switch.ch/pool/4/mirror/scientificlinux/7rolling/x86_64/os/Packages/junit-4.11-8.el7.noarch.rpm',
    $gl_name = 'glibc-2.9',
    $gl_source = 'ftp://ftp.pbone.net/mirror/www.arklinux.org/obsolete-packages/x86_64/glibc-2.9-3ark.x86_64.rpm',
    $log4_name = 'log4j12-1.2.17',
    $log4_source = 'ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/development/rawhide/x86_64/os/Packages/l/log4j12-1.2.17-7.fc22.noarch.rpm',
    $mock_name = 'mockito-1.9.0',
    $mock_source = 'ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/releases/18/Everything/x86_64/os/Packages/m/mockito-1.9.0-7.fc18.noarch.rpm',
    $netty_name = 'netty3-3.6.6',
    $netty_source = 'ftp://ftp.pbone.net/mirror/distrib-coffee.ipsl.jussieu.fr/mageia/distrib/cauldron/x86_64/media/core/release/netty3-3.6.6-5.mga5.noarch.rpm',
    $slf_name = 'slf4j-1.7.7',
    $slf_source = 'ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/development/rawhide/x86_64/os/Packages/s/slf4j-1.7.7-3.fc22.noarch.rpm',
    $zooj_name = 'zookeeper-java-3.4.6',
    $zooj_source = 'ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/development/rawhide/x86_64/os/Packages/z/zookeeper-java-3.4.6-2.fc22.x86_64.rpm',
    $mvn_name = 'maven-3.1.1',
    $mvn_source = 'ftp://rpmfind.net/linux/fedora/linux/releases/20/Everything/x86_64/os/Packages/m/maven-3.1.1-13.fc20.noarch.rpm',
    $cgl_name = 'cglib-2.2',
    $cgl_source = 'ftp://rpmfind.net/linux/fedora/linux/releases/20/Everything/x86_64/os/Packages/c/cglib-2.2-17.fc20.noarch.rpm',
    $osgi_name = 'OSGi-bundle-ant-task-0.2.0',
    $osgi_source = 'ftp://rpmfind.net/linux/fedora/linux/releases/21/Everything/x86_64/os/Packages/o/OSGi-bundle-ant-task-0.2.0-0.12.svn1242.fc21.noarch.rpm',
    $obj_name = 'objenesis-1.2',
    $obj_source = 'ftp://rpmfind.net/linux/fedora/linux/releases/20/Everything/x86_64/os/Packages/o/objenesis-1.2-16.fc20.noarch.rpm'
  ) {

  file { ["/tmp", "/tmp/rep", "/tmp/rep/$architecture", "/tmp/rep/$architecture/RPMS"]:
      ensure => "directory",
  }

  exec { 'download_rpms':
    command => 
    "/usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${zoo_name}.rpm $zoo_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${cs_name}.rpm $cs_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${jl_name}.rpm $jl_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${jt_name}.rpm $jt_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${ju_name}.rpm $ju_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${gl_name}.rpm $gl_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${log4_name}.rpm $log4_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${mock_name}.rpm $mock_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${netty_name}.rpm $netty_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${slf_name}.rpm $slf_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${zooj_name}.rpm $zooj_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${mvn_name}.rpm $mvn_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${cgl_name}.rpm $cgl_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${osgi_name}.rpm $osgi_source &&
     /usr/bin/curl -Lo /tmp/rep/$architecture/RPMS/${obj_name}.rpm $obj_source",
    require => File["/tmp/rep/$architecture/RPMS"],
  }

  yumrepo { 'rep':
    baseurl => "file:///tmp/rep/$architecture",
    gpgcheck => 0,
    enabled => 1,
    priority => 1,
    require => Exec['create_repo'],
  }

  exec { 'create_repo':
    command => "createrepo /tmp/rep/$architecture",
    require => [Package['createrepo'], Exec['download_rpms']],
    path => ['/bin', '/usr/bin/'],
  }

  package { 'createrepo':
    ensure => installed,
  }

  package { "zookeeper.x86_64":
    ensure => installed,
    require => Exec[['download_rpms'], ['create_repo']],
  }

  file { "":
    ensure => file,
    source => 'puppet:///modules/zookeeper/',
    path => '/tmp/rep/$architecture/RPMS',
    owner => root,
    group => root,
    mode => '0755',
  }
}
