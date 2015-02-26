class gitlab::demo {
  package { 'git':
    ensure => 'installed',
  }->
  
  file { '/var/opt/gitlab/backups/1423440833_gitlab_backup.tar':
    owner => 'git',
    group => 'git',
    mode => '0644',
    source => 'puppet:///modules/gitlab/1423440833_gitlab_backup.tar',
    notify => Exec['gitlab-restore-demo-backup'],
    require => Exec['gitlab-reconfigure'],
  }->

  exec { 'gitlab-restore-demo-backup':
    command => "/bin/echo yes | /bin/gitlab-rake gitlab:backup:restore > /dev/null",
    refreshonly => true,
    notify => Exec['puppet-demo-set-head'],
  }->

  # For some reason, the gitlab backup doesn't respect the the HEAD and always
  # sets it to test.
  exec { 'puppet-demo-set-head':
    cwd => "/var/opt/gitlab/git-data/repositories/puppet/puppet-repository.git",
    command => "/bin/git symbolic-ref HEAD refs/heads/production",
    refreshonly => true,
  }
}
