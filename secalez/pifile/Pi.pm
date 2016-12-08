#!/usr/bin/perl

# project info file.

package pifile::Pi;

use strict;
use warnings;
use Exporter;

use vars qw /@ISA @EXPORT @EXPORT_OK/;

@ISA = qw /Exporter/;
@EXPORT = @EXPORT_OK;
@EXPORT_OK = qw /
new create_pifile _dbg_print/;

my $fname = "pi.sk";
# my %default_val = (
# 	version => '1.0',
# 	name => 'secalez-proj',
# 	author => 'ez',
# 	root => '.',
# 	output => 'target/classes',
# 	depend => 'lib/',
# 	src => 'src/main',
# 	test => 'src/test',
# 	info => ''
# );

sub new {
	my ($class, $param) = @_;
	my $this = $param;

	# parameter initialize.
	# my %params = %$param;
	# while (my ($k, $v) = each %params) {
	# 	$this -> {$k} = $v;
	# }

	# foreach my $k (keys %default_val) {
	# 	unless (exists $param {$k} || defined ($param {$k})) {
	# 		$this -> {$k} = $default_val {$k}
	# 	} else {
	# 		$this -> {$k} = $param {$k};
	# 	}
	# }

	bless $this, $class;
	$this;
}

# TODO...
sub load {
	my ($class) = shift;
	my $this = {};
}

sub create_pifile {
	my $this = shift;
	my $file = $this -> get_path;
	if ( -r $file ) {
ASK:
		print "Existing a project in current path: $file; Create a new one in any case? [y|n]: ";
		my $repo = <>;
		exit (0) if $repo =~ /n|no/i;
		goto CREATE if $repo =~ /y|yes/i;
		goto ASK;
	}
CREATE:
	$this -> _create_pifile;
}

sub _create_pifile {
	my $this = shift;
	my $fpath = $this -> get_path;
	&_check_or_create ($this -> {root});
	open F, "+>", $fpath
		or die "Create pi file error: $!\n";
	while (my ($k, $v) = each %{$this}) {
		print F "$k = $v\n";
	}

	close F;
}

sub _dbg_print {
	my ($this) = shift;
	while (my ($k, $v) = each %{$this}) {
		print "$k => $v\n";
	}
}

# check root path and create.
sub _check_or_create {
	my $root = shift;
	`mkdir $root` unless ( -x $root );
}

sub get_path {
	my $this = shift;
	return $this -> {root} . "/" . $fname;
}


1;
__END__

