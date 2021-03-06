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
    gitlab_demo => true,
  }
}

node 'puppet.local.vm' {
  include common
  class { 'puppetmaster': }

  class { 'r10k':
    version           => '1.3.2',
    sources           => {
      'puppet' => {
        'remote'  => 'git@gitlab.local.vm:puppet/puppet-repository.git',
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }
    },
    purgedirs         => ["${::settings::confdir}/environments"],
    manage_modulepath => false,
  }
}

node 'control.local.vm' {
  include common::hosts
  include common::ntp
  class { 'salt::master': }
}

node /^runner\d+$/ {
  include common
  class { 'gitlab::runner':
    ci_external_url => 'http://ci.local.vm',
    ci_registration_token => $::ci_token,
  }
}

node /^host\d+$/ {
  include common
}
