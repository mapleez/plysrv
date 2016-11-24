#!/usr/bin/perl

package Getopt;

use strict;
use warnings;
use vars qw /@ISA @EXPORT/;

require Exporter;
@ISA = qw (Exporter);
@EXPORT = qw /opt parse arg _print_all/; # _print_all/;

my $VERSION = "v1.1";
my %options = ();
my %options_long = ();
my %reg_args = ();
my @reg_args = ();
my @argtmp = (); # last version

=head
Register options
 return 0 if input is error.
 return -1 if failure.
 return 1 if successful.
=cut;
sub opt {
	if (3 > scalar @_) {
		die "Error, arguments is not enough.\n";
	}
	my ($short, $long, $param, $defval) = @_;

	if (length $short && 
		! exists $options {$short}) {

		# each option entry
		$options {$short} = {
			short => $short, 
			long  => $long, 
			param => $param, 
			value => eval {
				my $v = ($defval ? $defval : '') 
					if $param;
				$v = ($defval ? 1 : 0) 
					unless $param;
			}
		};
		# get reference for long option.
		$options_long {$long} = $options {$short}; 
		return 1;
	}
	return -1;
}

=head
now all the argument will be appended after all options.
That is the format below:
  $ scanjar [options ...] [arguments ...]
=cut;
sub arg {
	my ($argname, $defval) = @_;

	if (length $argname &&
		! exists $reg_args {$argname}) {
		$reg_args {$argname} = {
			argname => $argname,
			index => $#reg_args != -1 ? ($#reg_args + 1) : 0,
			value => $defval ? $defval : ''
		};
		push @reg_args, $reg_args {$argname}; # stored a hash
		return 1;
	}
	return -1;
}

=head
Parse option and return.
param: args
=cut;
sub parse {
	my @args = @_; # @ARGV;
	my $reg_arg_index = 0;
	for (my $i = 0; $i <= $#args; $i ++) {
		my $a = $args [$i];

		# long or short param
		my ($opt, $entry) = (&_parse_opt ($a), undef);
		if (defined $opt) {
			$entry = $options_long {$opt} 
				if 1 < length $opt && exists $options_long {$opt};
			$entry = $options {$opt}
				if 1 == length $opt && exists $options {$opt};

			unless (defined $entry) {
				die "Error, unknown option \'$opt\'\n";
			}

			$entry -> {value} = $args [++ $i]
				if $entry -> {param};
			$entry -> {value} = 1
				unless $entry -> {param};
		} else {
			$reg_args [$reg_arg_index ++] -> {value} = $a;
			push @argtmp, $a;
		}
	}
}

=head Parse option and return.
return parsed option
  if length > 1, long option
  if length == 1, short option
  if return -1, arg
  die if error.
=cut;
sub _parse_opt {
	my ($opt, $short, $long) = 
		(shift, "", "");
	die "Error input param in &_parse_opt\n"
		unless length $opt;
	if ($opt =~ /^-([a-zA-Z])|^--([a-zA-Z]\w*)/) {
		($short, $long) = ($1, $2);
		return $short if $short && 1 == length $short;
		return $long if $long && 1 < length $long;
		die "Error input option \'$opt\'\n";
	} 
	undef;
}

sub get_op_val {
	my $opt = shift;
	print "Error, optname empty..\n"
		if !defined $opt or length $opt;
}

# for debug
sub _print_all {
	print "Input options: @ARGV\n";
	print "-" x 20 , "\n";

	while (my ($key, $val) = each %options) {
		print "$key:\n";
		while (my ($k, $v) = each %$val) {
			print " $k => $v\n";
		}
	}

	print "-" x 7, " tmp args ", "-" x 7, "\n";
	print "@argtmp\n";

	print "-" x 7, " register args ", "-" x 7, "\n";
	while (my ($key, $val) = each %reg_args) {
		print "$key:\n";
		while (my ($k, $v) = each %$val) {
			print " $k => $v\n";
		}
	}

	print "-" x 7, " register args arr", "-" x 7, "\n";
	foreach my $hash (@reg_args) {
		while (my ($k, $v) = each %$hash) {
			print " $k => $v\n";
		}
	}
}


1;

__END__

author : ez
date : 2016/9/18
describe : 
	1) short option start with '-'
	2) long option start with '--'
	3) the short option cannot be combined with each other starting with '-'. That is.
		The format --abcd (-a -b -c -d) is not supported.
	4) when input an unregister option, print error text and continue parsing next input.


