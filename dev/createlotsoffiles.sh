#!/bin/bash
cd /root
mkdir smarties
mkdir -p smarties/dir{00..99}
for directory in smarties/dir{00..99} ; do
  for filename in myfile.{00..10} ; do
    touch $directory/$filename
    dd if=/dev/zero of=$directory/$filename bs=100k count=5 2>&1 &> /dev/null 
  done
done
