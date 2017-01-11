#!/usr/bin/perl

# Author : ez
# Date : 2017/1/11
# Description : Testing utils::Daemon

use strict;
use warnings;

use lib ("..");
use utils::Daemon qw /daemonize/;

&daemonize ("testing");

while (1) {
	print ".";
}


__END__

