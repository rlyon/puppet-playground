class salt (
  $salt_master = $::salt::params::salt_master,
) inherits salt::params {
  include ::epel
}
