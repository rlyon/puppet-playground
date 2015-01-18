class gitlab::users {
  file { '/etc/gitlab/users.rb':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/gitlab/users.rb',
    notify => Exec['gitlab-add-default-users'],
    require => Package[gitlab]
  }

  exec { 'gitlab-add-default-users':
    cwd => '/etc/gitlab',
    command => '/usr/bin/gitlab-rails runner /etc/gitlab/users.rb',
    refreshonly => true,
  }
}
