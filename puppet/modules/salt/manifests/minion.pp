class salt::minion (
  $salt_master = $::salt::params::salt_master,
) inherits salt::params {
  include salt
  
  package { 'salt-minion':
    ensure => 'installed',
  }

  file { '/etc/salt/minion':
    owner => 'root',
    group => 'root',
    content => "master: $salt_master",
  }

  service { 'salt-minion':
    ensure => 'running',
    enable => true,
  }
}
