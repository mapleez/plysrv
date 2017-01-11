#!/usr/bin/perl

#############################################################
# Author : ez
# Date : 2017/1/6
# Description : Utiils for Daemon.
############################################################# 

package utils::Daemon;

use strict;
use warnings;
use vars qw /@ISA @EXPORT/;
use POSIX();

require Exporter;
@ISA = qw (Exporter);
@EXPORT = qw /daemonize/;

sub daemonize {
	my ($stdout_file, $stderr_file) = @_;
	$stderr_file = $stdout_file unless 
		defined $stderr_file;
	my $PWD = ".";

	defined (my $pid = fork) 
		or die "Fork daemon error: $!\n";
	
	# Exit parent process.
	exit 0 if $pid; 

	# Detach the child from the terminal 
	# (No controlling tty). make it the 
	# session-leader and the process-group-leader
	# of a new process group.
	die "Cannot detach from controlling terminal: $!\n"
		if &POSIX::setsid () < 0;

	# chdir to $PWD.
	die "Can't chdir to $PWD: $!\n" unless chdir $PWD;

	# Redirect stdout and stderr.
	open STDOUT, '+>', $stdout_file;
	if ($stderr_file eq $stdout_file) {
		open STDERR, '>&', STDOUT;
	} else {
		open STDERR, '+>', $stderr_file;
	}

	return $$;
}

__END__
