#!/usr/bin/perl

package tool::secalez::create;

use strict;
use warnings;

use Getopt::Args;

my $cmd = "create";

sub run  {
	my ($self, $opts) = @_;
	print $opts -> {name}, "\n";
}


1;

__END__
