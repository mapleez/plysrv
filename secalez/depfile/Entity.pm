#!/usr/bin/perl

#
# Every depending entity for every jar file, one per line.
# Entity format: 
# ________________________________________________
#| number | filename | srcpath | scope | filepath | 
#|________|__________|_________|_______|__________|
#
# Each field above will be separated by a comma (,)
#
#  - number : The rank of load order.
#  - filename : jar file name.
#  - srcpath : The source path of a jar file. The jar file will be  copied on createing dependence file.
#  - scope : Specified how and when the jar file will be used. The value of this field must be: compile, test. Note at this version I only define the 2 values.
#  - filepath ; The file destination path. The file from src path will be copied into dest path on creating project.
#

package depfile::Entity;

use strict;
use warnings;

use Exporter;
use vars qw /@ISA @EXPORT @EXPORT_OK/;

@ISA = qw /Exporter/;
@EXPORT = @EXPORT_OK;
@EXPORT_OK = qw /
	new get_dst_path
	get_src_path
	_dbg_print
/;

my %default_val = (
	number => 0,
	filename => "",
	srcpath => "",
	scope => "",
	# Get this value from pifile::Pi -> {depend}.
	filepath => 'lib/'
);

# All the dependence jar.
my %entity = ();

sub new {
	my ($class, %param) = @_;
	my $this = {};
	foreach my $k (keys %default_val) {
		unless (exists $param {$k}) {
			$this -> {$k} = $default_val {$k};
		} else {
			$this -> {$k} = $param {$k};
		}
	}
	bless $this, $class;
	$this;
}

sub get_dst_path {
	my $this = shift;
	return $this -> {filepath} . "/" . 
		$this -> {name};
}

sub get_src_path {
	my $this = shift;
	return $this -> {srcpath} . "/" . 
		$this -> {name};
}

sub _dbg_print {
	my $this = shift;
	while (my ($k, $v) = each %{$this}) {
		print "$k => $v\n";
	}
}

1;

__END__

