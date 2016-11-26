#!/usr/bin/perl

package depfile::Entity;

use strict;
use warnings;

use Exporter;
use List::Util qw /first/;
use vars qw /@ISA @EXPORT @EXPORT_OK/;

@ISA = qw /Exporter/;
@EXPORT = @EXPORT_OK;
@EXPORT_OK = qw /new add exist remove/;

# A singleton.
my @depends = ();

sub new {
	my ($class, @elms) = @_;
	map { push @depends, $_; } @elms;
	$this = \@depends;
	bless $this, $class;
	$this;
}

sub add {
	my ($this, @elms) = @_;
	my $i = 0;
	foreach (@elms) {
		if ($this -> exist ($_)) {
			my $name = $_ -> {name};
		ASK:
			print "The jar file '$name' exists, import it? [y|n]: ";
			my $repo = <>;
			next if $repo =~ /n|no/i;
			goto ASK unless $repo =~ /n|no|yes|y/i;
		}
		push @{$this}, $_; 
		$i ++; 
	}
	$i;
}

# Return the element or undef;
sub exist {
	my ($this, $k) = (shift, shift);
	&first { $_ -> {name} eq $k } @$this;
}

sub remove {
	my ($this, @elms) = @_;
	my ($idx, $i) = (0, 0);
	foreach (@elms) {
		if ($this -> exist ($_)) {
			$i ++;
			@{$this} [$idx] = undef; # We just set undef.
		}
		$idx ++;
	}
	$i;
}

1;

__END__

