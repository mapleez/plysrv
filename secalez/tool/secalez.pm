#!/usr/bin/perl

package tool::secalez;

use strict;
use warnings;

# https://metacpan.org/pod/Getopt::Args
use Getopt::Args;

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

opt version => (
	isa => 'Str',
	alias => 'v',
	comment => 'The version of project. Default version = 1.0;',
	default => '1.0'
);

opt name => (
	isa => 'Str',
	alias => 'n',
	comment => 'The name of project. Describe the project.',
	default => "secalez-proj"
);

opt author => (
	isa => 'Str',
	alias => 'a',
	comment => 'The creator.',
	default => 'ez'
);

opt output => (
	isa => 'Str',
	alias => 'o',
	comment => 'Output path. The default is ROOT/target/classes',
	default => 'target/classes'
);

opt root => (
	isa => 'Str',
	alias => 'r',
	comment => 'Root for project.',
	default => '.'
);

opt depend => (
	isa => 'Str',
	alias => 'd',
	comment => 'The dependency path. Default = lib/',
	default => 'lib/'
);


opt src => (
	isa => 'Str',
	alias => 's',
	comment => 'The source path. Default = src/main',
	default => 'src/main'
);

opt test => (
	isa => 'Str',
	alias => 't',
	comment => 'The test path. Default = src/test',
	default => 'src/test'
);


subcmd (
	cmd => 'run',
	comment => 'Run command that I defined.'
);

# my $ref = optargs;
# print &usage ($ref);

1;

