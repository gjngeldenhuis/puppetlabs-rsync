# Things to change

* Rsync put and get usage is stupid. It is just source and destination so should be able to make provision for that. Source and destination could be either local or remote.
* Add params class to handle multiple platforms
* Add more supported parameters for rsync.
* Red Hat as usual uses an ancient version of rsync. There is new parameters available that should only be supported for certain versions and/or certain platforms.
* What about rsync on Windows. Would be cool... maybe later
* Make ipv4 and ipv6 agnostic.


# Use cases
* I have a 1Tb directory that needs syncing. I care that it is configured correctly and that we create a cron job for it and kick of the job. I don't want to have puppet wait on the rsync to complete. Puppet should configure it correctly though. (defined type)

* I have a small set of directories that I want to have rsynced. I care about the fact that it should be synced, the status of the sync. Knowing the status of the sync would allow me to act on its status and add dependencies. Eg. Only start service after rsync job becomes synced. (custome type/provider)
* I want to run rsync in daeomon mode with all of the possible bells and whistles. However it then becomes a service, so do I want puppet to actuall install a service config file? Do I rely on the packager to do that? rpm, deb and friends... Red Hat still installs a xinetd entry. 
* Puppet should take care of ALL options and check them for sanity before passing over to rsync. It should be my rsync nanny.
* There is some docs on the net that seems to suggest platforms that change underlying filesystem settings which causes rsync to continously sync. If rsync puppet could automatically take care of this it would be awesome.
* Rsync allows for authentication.

* Add files with spaces in them as part of the test case


Ways of using rsync
rsync -av machine2:/root/one :/root/two machine2:/root/{three,four,five} dest/


What is named module in rsync daemon?
