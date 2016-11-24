#!/usr/bin/perl

package secalez;

use strict;
use warnings;

# https://metacpan.org/pod/Getopt::Args
# use Getopt::Args;
use OptArgs;

# The argument to indicate tool.
arg tool => (
	isa => 'SubCmd',
	required => 1,
	comment => 'Specified the tool name to invoke.'
);

subcmd (
	cmd => 'create',
	comment => 'Create command that I defined.'
);

subcmd (
	cmd => 'run',
	comment => 'Run command that I defined.'
);

my $ref = optargs;
# print &usage ($ref);


