class salt::master inherits salt {
  package { 'salt-master':
    ensure => 'installed',
  }->

  file { '/etc/salt/master':
    owner => 'root',
    group => 'root',
    content => 'interface: 0.0.0.0',
    notify => Service['salt-master'],
  }->

  service { 'salt-master':
    ensure => 'running',
    enable => true,
  }
}
