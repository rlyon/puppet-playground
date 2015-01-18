Package { allow_virtual => false, }

node 'ci.local.vm' {
  include common
  class { 'gitlab':
    external_url => "http://localhost",
    ci_external_url => "http://ci.local.vm",
    gitlab_server_urls => ['http://gitlab.local.vm'],
    gitlab_unicorn_enable => false,
    gitlab_sidekiq_enable => false,
  }
}

node 'gitlab.local.vm' {
  include common
  class { 'gitlab':
    ci_external_url => "http://ci.local.vm",
    gitlab_default_users => true,
  }
}

node 'puppet.local.vm' {
  include common
}

node /^web\d+$/ {
  include common
}
