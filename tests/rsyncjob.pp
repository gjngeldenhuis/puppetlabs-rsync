rsync::job { 'test132':
  source          => '/blah',
  source_host     => 'myserver',
  connection_type => 'rsyncdaemon',
  verbosity       => 'summary',
  destination     => '/dest',
  jobtype         => 'execblocking',
  modify_window   => '2',
}