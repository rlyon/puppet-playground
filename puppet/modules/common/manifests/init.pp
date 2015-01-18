class common {
	class { '::ntp':
		servers => [
			'0.pool.ntp.org',
			'1.pool.ntp.org',
			'2.pool.ntp.org',
			'3.pool.ntp.org',
		],
		restrict => [
			'127.0.0.1'
		],
	}

	file { '/etc/hosts':
		owner => 'root',
		group => 'root',
		mode => '0644',
		content => template('common/hosts.erb'),
	}
}
