define rsync::job (
  $source           = '',
  $destination      = '',
  $source_host      = undef,
  $destination_host = undef,
  $connection_type  = 'remoteshell',
  $cron_entry       = undef,
  $jobtype          = '',
  $verbosity        = 'none',
  $quiet            = false,
  $no_motd          = false,
  $ignore_times     = false,
  $size_only        = false,
  $modify_window    = undef, # Unit is seconds
  $checksum         = false,
  $archive          = false,

) {

# Validate values	
  validate_re($connection_type, '(^remoteshell$|^rsyncdaemon$)')
  validate_re($jobtype, '^cron$|^execbackground$|^execblocking$')
  validate_re($verbosity,'^none$|^summary$|^completelisting$|^debug1$|^debug2$|^debug3$')
  validate_bool($quiet)
  validate_bool($no_motd)
  validate_bool($ignore_times)
  validate_bool($size_only)
  validate_number($modify_window)
  validate_bool($checksum)
  validate_bool($archive)
   
  $connenction_seperator = $connection_type ? {
  	'remoteshell' => ':',
  	'rsyncdaemon' => '::',
  }

  $verbosity_flag = $verbosity ? {
  	'none'            => '',
  	'summary'         => ' -v',
  	'completelisting' => ' -vv',
  	'debug1'          => ' -vvv',
  	'debug2'          => ' -vvvv',
  	'debug3'          => ' -vvvvv',
  }

# Logic constraints
  if $source_host and $destination_host {
  	fail('The source and destination cannot both be remote') # Blatantly copied from the rsync message
  }

# Make sure we don't use the seperator twice.
  if $source_host {
  	$source_seperator = $connenction_seperator
  } else {
    $destination_seperator = $connenction_seperator
  }

  if $quiet { $quiet_flag = ' -q'}
  if $no_motd { $no_motd_flag = ' --not-motd' }
  if $ignore_times { $ignore_times_flag = ' --ignore-times'}
  if $size_only { $size_only_flag = ' --size-only'}
  if $modify_window { $modify_window_flag = " --modify_window=${modify_window}"}
  if $checksum { $checksum_flag = "  --checksum"}
  if $archive { $archive_flag = " --archive"}


  $rsync_source = "${source_host}${source_seperator}${source}"
  $rsync_destination = "${destination_host}${destination_seperator}${destination}"

# Probably breaks style guide but it is imminently more readable and debuggable
  $rsync_flags = "\
${verbosity_flag}\
${quiet_flag}\
${no_motd_flag}\
${ignore_times_flag}\
${size_only_flag}\
${modify_window_flag}\
${checksum_flag}\
${archive_flag}"

  $rsync_flagss = chomp($rsync_flags)
  $rsync_full_command = "rsync $rsync_flagss $rsync_source $rsync_destination"

  notify { 'rsync connection string':
    message => chomp("$rsync_full_command")
  }

  case $jobtype {
  	'cron':{
  		fail('not yet supported')

  	}

  	'execbackground': {

  	}

  	'execblocking': {

  	}
  }
# TODO
# Figure out some way to log all output to syslog or somewhere specified by user. 
# Add some stage add yes/no

# Will need to cater for at least the following:
# rsync -t   *.c           foo:src/
# rsync -avz foo:src/bar   /data/tmp
# rsync -avz foo:src/bar/  /data/tmp 
# rsync -av  host:         /dest
# rsync -av  host::module  /dest
# rsync -av  host:’file\ name\ with\ spaces’ /dest
# rsync -av  host::src     /dest
# rsync -av -e "ssh -l ssh-user" rsync-user@host::module /dest
# rsync -av host:file1 :file2 host:file{3,4} /dest/  # multiple source files, one destination.
# rsync://[USER@]HOST[:PORT]/SRC... [DEST]
#
# Support all the 10 million options.

# source and destination can't both be remote but at least one can be.
}