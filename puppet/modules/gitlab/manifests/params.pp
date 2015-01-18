class gitlab::params {
  $gitlab_download_location = "/usr/local/rpms"
  $gitlab_version           = "7.6.2"
  $gitlab_omnibus_version   = "5.3.0.ci.1-1"
  $gitlab_filename          = "gitlab-${gitlab_version}_omnibus.${gitlab_omnibus_version}.el${operatingsystemmajrelease}.${architecture}.rpm"
  $gitlab_url               = "https://downloads-packages.s3.amazonaws.com/centos-${operatingsystemrelease}/${gitlab_filename}"
  $gitlab_deps              = ['openssh-server', 'postfix', 'wget']

  $external_url             = "http://${fqdn}"
  $ci_external_url          = undef

  $gitlab_server_urls       = undef
  $gitlab_unicorn_enable    = undef
  $gitlab_sidekiq_enable    = undef

  $gitlab_default_users     = false
}
