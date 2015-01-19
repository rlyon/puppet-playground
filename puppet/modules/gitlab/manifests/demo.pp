class gitlab::demo {
  file { '/var/opt/gitlab/backups/1421633623_gitlab_backup.tar':
    owner => 'git',
    group => 'git',
    mode => '0644',
    source => 'puppet:///modules/gitlab/1421633623_gitlab_backup.tar',
    notify => Exec['gitlab-restore-demo-backup'],
    require => Package['gitlab'],
  }

  exec { 'gitlab-restore-demo-backup':
    command => "/bin/echo yes | /bin/gitlab-rake gitlab:backup:restore > /dev/null",
    refreshonly => true,
  }
}
