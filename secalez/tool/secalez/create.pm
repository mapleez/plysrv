#!/usr/bin/perl

package tool::secalez::create;

use strict;
use warnings;

use FindBin; 
use lib "$FindBin::Bin";

use Getopt::Args;
use pifile::Pi qw/new _dbg_print/;

my $cmd = "create";

# TODO...
sub run  {
	my ($self, $opts) = @_;
	my $pi = new pifile::Pi ($opts);
	# $pi -> _dbg_print;
	$pi -> create_pifile;
}


1;

__END__
