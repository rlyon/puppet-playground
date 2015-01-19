class puppetmaster {
  $puppetmaster_deps = [
    'puppet-server', 'httpd', 'httpd-devel', 'mod_ssl',
    'gcc-c++', 'libcurl-devel',
    'zlib-devel', 'make', 'automake',  'openssl-devel',
  ]

  package { $puppetmaster_deps:
    ensure => 'installed'
  }->

  package { 'passenger':
    provider => 'gem',
    ensure => '4.0.57',
  }

  exec { 'install-apache-passenger-modules':
    command => 'passenger-install-apache2-module -a',
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    unless => 'test -f /usr/local/share/gems/gems/passenger-4.0.57/buildout/apache2/mod_passenger.so',
    require => Package['passenger'],
  }

  file { '/etc/httpd/conf.d/puppetmaster.conf':
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template('puppetmaster/puppetmaster.conf.erb'),
    notify => Service['httpd'],
    require => Exec['install-apache-passenger-modules'],
  }

  file { '/usr/share/puppet/rack':
    ensure => directory,
    owner => 'puppet',
    group => 'puppet',
    require => Package['puppet-server'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd':
    ensure => directory,
    owner => 'puppet',
    group => 'puppet',
    require => File['/usr/share/puppet/rack'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd/public':
    ensure => directory,
    owner => 'puppet',
    group => 'puppet',
    require => File['/usr/share/puppet/rack/puppetmasterd'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd/tmp':
    ensure => directory,
    owner => 'puppet',
    group => 'puppet',
    require => File['/usr/share/puppet/rack/puppetmasterd'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd/config.ru':
    owner => 'puppet',
    group => 'puppet',
    mode => 0644,
    source => 'puppet:///modules/puppetmaster/config.ru',
    notify => Service['httpd'],
    require => File['/usr/share/puppet/rack/puppetmasterd'],
  }

  # CA list was used because it does nothing (since we dont have anything to list)
  # but it does have the side effect of generating the certs if they done exist.
  exec { 'generate-initial-certs':
    command => 'puppet master',
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    unless => 'test -f /var/lib/puppet/ssl/certs/puppet.local.vm.pem',
    require => Package['puppet-server'],
  }

  service { 'puppetmaster':
    ensure => stopped,
    enable => false
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }

  Ini_setting {
    ensure => present,
    path   => "${::settings::confdir}/puppet.conf",
  }

  ini_setting { 'configure-environmentpath':
    section => 'main',
    setting => 'environmentpath',
    value   => "${::settings::confdir}/environments",
  }

  ini_setting { 'configure-basemodulepath':
    section => 'main',
    setting => 'basemodulepath',
    value   => "${::settings::confdir}/modules",
  }
}
