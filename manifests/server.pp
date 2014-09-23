# Class: rsync::server
#
# The rsync server. Supports both standard rsync as well as rsync over ssh
#
# Requires:
#   class xinetd if use_xinetd is set to true
#   class rsync
#

# The server can either be xinetd or a daemon. xinetd seems old but should still work. chkconfig can enable it but
# puppet provider on Red Hat can't. When it is running as a daemon it would seem appropriatte that proper chkconfig 
# scripts would be needed to manage it as a service rather than mess around with already solved solutions.
# So add a chkconfig compat script in CentOS 5 - 6
# Add a systemd script in Centos 7.

#class rsync::server(
#  $use_xinetd = 'xinetd',
#  $address    = '0.0.0.0',
#  $motd_file  = 'UNSET',
#  $use_chroot = 'yes',
#  $uid        = 'nobody',
#  $gid        = 'nobody'
#) inherits rsync {


# So rsync can be called via xinetd or it can run permanently stand alone. However on CentOS 6.x it does not come
# with an appropriate service management file so this will need to be created and tested.

# When rsync runs as a standalone service it will either just allow anyone access or have password controlled access
# This password controled access is weak and using a different transport mechanism increases the security because 
# authentication is not the responsibility of the transport medium. Typically ssh.

# To save people from themeselves we should probably not allow anything other than ssh.

# rsync as a service/class
# ~~~~~~~~~~~~~~~~~~~~~~~~
# * xinetd
# * system service
#
# This should enable you to configure the service and populate a config file with modules 



# rsync as an action/definined resource
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# * cronjob
# * run as blocking exec
# * run as non blocking exec by adding daemon flag

class rsync::server (
  $servertype = '',
  $port        = '873',
  $address      = undef,
) inherits rsync {

  validate_re($::rsync::server::servertype, '(^xinetd$|^service$)')

  case $::rsync::server::servertype {
    'xinetd': {
      include xinetd # This module creates a whole load of guff that is not needed...
      notify {'I should really be working':}
      xinetd::service { 'rsync':
        port           => $::rsync::server::port,
        server         => $rsync_daemon,
        server_args    => '--daemon', # Potentinally add abbility to add more arguments here
        log_on_failure => 'USERID', # This parameter is not alligned, fix and push to xinetd module.
        require     => Package[$::rsync::params::packages]
      }
    }

    'service': { 
      fail('not yet supported')
      # add service file
      # add service management
      # add dependencies
    }
  }


#  $rsync_fragments = '/etc/rsync.d'

#  if $use_xinetd {
#    include xinetd
#    xinetd::service { 'rsync':
#      bind        => $address,
#      port        => '873',
#      server      => '/usr/bin/rsync',
#      server_args => "--daemon --config ${conf_file}",
#      require     => Package['rsync'],
#    }
#  } else {
#    service { 'rsync':
#      ensure     => running,
#      enable     => true,
#      hasstatus  => true,
#      hasrestart => true,
#      subscribe  => Exec['compile fragments'],
#    }
#
#    if ( $::osfamily == 'Debian' ) {
#      file { '/etc/default/rsync':
#        source => 'puppet:///modules/rsync/defaults',
#        notify => Service['rsync'],
#      }
#    }
#  }

#  if $motd_file != 'UNSET' {
#    file { '/etc/rsync-motd':
#      source => 'puppet:///modules/rsync/motd',
#    }
#  }

#  file { $rsync_fragments:
#    ensure  => directory,
#  }

  # Template uses:
  # - $use_chroot
  # - $address
  # - $motd_file
#  file { "${rsync_fragments}/header":
#    content => template('rsync/header.erb'),
#  }

#  file { $conf_file:
#    ensure => present,
#  } ~> Exec['compile fragments']

  # perhaps this should be a script
  # this allows you to only have a header and no fragments, which happens
  # by default if you have an rsync::server but not an rsync::repo on a host
  # which happens with cobbler systems by default
#  exec { 'compile fragments':
#    refreshonly => true,
#    command     => "ls ${rsync_fragments}/frag-* 1>/dev/null 2>/dev/null && if [ $? -eq 0 ]; then cat ${rsync_fragments}/header ${rsync_fragments}/frag-* > ${conf_file}; else cat ${rsync_fragments}/header > ${conf_file}; fi; $(exit 0)",
#    subscribe   => File["${rsync_fragments}/header"],
#    path        => '/bin:/usr/bin:/usr/local/bin',
#  }
}
