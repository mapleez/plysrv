#!/usr/bin/perl


use strict;
use warnings;
use pifile::Pi;

my $pi = new pifile::Pi (
	name => 'SparkTesting',
	version => 'vv1.1',
	info => 'This is my first Scala project.'
);
# print $pi;
$pi -> _dbg_print;

$pi -> create_new;


__END__

