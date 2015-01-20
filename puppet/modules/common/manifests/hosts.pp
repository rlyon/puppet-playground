class common::hosts {
  file { '/etc/hosts':
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('common/hosts.erb'),
  }
}
