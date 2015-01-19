class gitlab(
  $gitlab_download_location = $::gitlab::params::gitlab_download_location,
  $gitlab_version           = $::gitlab::params::gitlab_version,
  $gitlab_omnibus_version   = $::gitlab::params::gitlab_omnibus_version,
  $gitlab_filename          = $::gitlab::params::gitlab_filename,
  $gitlab_url               = $::gitlab::params::gitlab_url,
  $gitlab_deps              = $::gitlab::params::gitlab_deps,
  $external_url             = $::gitlab::params::external_url,
  $ci_external_url          = $::gitlab::params::ci_external_url,
  $gitlab_server_urls       = $::gitlab::params::gitlab_server_urls,
  $gitlab_unicorn_enable    = $::gitlab::params::gitlab_unicorn_enable,
  $gitlab_sidekiq_enable    = $::gitlab::params::gitlab_sidekiq_enable,
  $gitlab_default_users     = $::gitlab::params::gitlab_default_users,
  $gitlab_demo              = $::gitlab::params::gitlab_demo,
) inherits gitlab::params {

  package { $gitlab_deps:
    ensure => installed,
  }

  service { 'sshd':
    ensure => running,
    enable => true,
  }

  service { 'postfix':
    ensure => running,
    enable => true,
  }

  file { $gitlab_download_location:
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0755',
  }

  exec { 'download-gitlab':
    cwd => $gitlab_download_location,
    command => "/usr/bin/wget ${gitlab_url} -O ${gitlab_download_location}/${gitlab_filename}",
    timeout => 900,
    creates => "${gitlab_download_location}/${gitlab_filename}",
    require => Package['wget'],
  }

  ###
  ### Chain order so we don't try to restore before the reconfigure
  ###
  package { 'gitlab':
    ensure => latest,
    source => "${gitlab_download_location}/${gitlab_filename}",
    require => Exec['download-gitlab'],
    provider => 'rpm'
  }->

  file { '/etc/gitlab/gitlab.rb' :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('gitlab/gitlab.rb.erb'),
    require => Package['gitlab'],
    notify => Exec['gitlab-reconfigure'],
  }->

  exec { 'gitlab-reconfigure':
    command => '/usr/bin/gitlab-ctl reconfigure',
    refreshonly => true,
  }

  if ($gitlab_default_users) {
    info('Setting the root password and adding the default user.')
    include ::gitlab::users
  }

  if ($gitlab_demo) {
    info('Restoring the demo repository and users.')
    include ::gitlab::demo
  }

  ####

  cron { 'Backup github database':
    command => '/opt/gitlab/bin/gitlab-rake gitlab:backup:create 1>/dev/null',
    user    => 'root',
    hour    => 2,
    minute  => 0,
    require => Package['gitlab'],
  }
}
