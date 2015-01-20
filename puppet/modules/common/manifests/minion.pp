class common::minion {
  class { 'salt::minion':
    salt_master => 'control.local.vm',
  }
}
