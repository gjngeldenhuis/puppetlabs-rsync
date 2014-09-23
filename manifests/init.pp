# Class: rsync
#
# This module manages rsync
#
class rsync inherits rsync::params {

  package { $packages:
    ensure => 'installed',
  }
}
