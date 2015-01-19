class gitlab::runner (
  $ci_external_url       = $::gitlab::params::ci_external_url,
  $ci_registration_token = $::gitlab::params::ci_registration_token,
) inherits gitlab::params {
  $runner_deps = [ "wget", "curl", "gcc", "libxml2-devel", "libxslt-devel",
    "readline-devel", "libcurl-devel", "glibc-devel", "openssh-server",
    "openssl-devel", "make", "git", "postfix", "libyaml-devel", "postgresql-devel",
    "libicu-devel", "ruby", "rubygem-bundler", "ruby-devel", "autoconf", "automake",
    "patch", "gcc-c++", "libstdc++-devel", ]

  package { $runner_deps:
    ensure => 'installed',
  }->

  group { 'gitlab_ci_runner':
    ensure => 'present',
  }->

  user { 'gitlab_ci_runner':
    ensure   => 'present',
    comment  => 'GitLab CI Runner',
    home     => '/opt/runner',
    shell    => '/bin/bash',
    system   => true,
    gid      => 'gitlab_ci_runner',
    managehome => true,
  }->

  vcsrepo { "/opt/runner/gitlab-ci-runner":
    ensure   => 'latest',
    provider => 'git',
    source   => 'https://gitlab.com/gitlab-org/gitlab-ci-runner.git',
    user     => 'gitlab_ci_runner',
    notify   => Exec['ci-runner-bundle-install']
  }->

  exec { 'ci-runner-bundle-install':
    cwd => "/opt/runner/gitlab-ci-runner",
    command => "/bin/bundle install --deployment",
    user     => 'gitlab_ci_runner',
    refreshonly => true,
    notify => Exec['ci-runner-register-node']
  }->

  exec { 'ci-runner-register-node':
    path => ['/bin', '/usr/bin'],
    cwd => "/opt/runner/gitlab-ci-runner",
    environment => ["CI_SERVER_URL=${ci_external_url}", "REGISTRATION_TOKEN=${ci_registration_token}"],
    command => "/bin/bundle exec ./bin/setup",
    user     => 'gitlab_ci_runner',
    refreshonly => true,
  }->

  file { '/etc/init.d/gitlab-ci-runner':
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/gitlab/gitlab-ci-runner',
  }->

  service { 'gitlab-ci-runner':
    ensure => 'running',
    enable => true,
  }

}
