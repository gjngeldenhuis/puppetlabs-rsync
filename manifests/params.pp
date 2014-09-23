class rsync::params {

  case $::osfamily {
    'RedHat': {
      $packages    = 'rsync'
      $conf_file   = '/etc/rsyncd.conf'
      $rsync_daemon = '/usr/bin/rsync'
    }

    'Debian': {
      $packages  = ['rsync','rsyncrypto']
      $conf_file = '/etc/rsyncd.conf' #check what this should be, probably the same according the man page but check anyway
      $rsync_daemon = '/usr/bin/rsync'
    }
     
    default: { fail("Platform $osfamily not supported.") }
  }
}
