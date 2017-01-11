#!/usr/bin/perl

package utils::FileUtils;

use strict;
use warnings;

my $fd = undef;


# TODO...
sub read_file {
	my $finfo = shift;
	my $ref = ref $finfo;
	if ('SCALAR' eq $ref) {
		open $fd, "<", $ref or 
			die "Error in open file $ref : $!\n";
		my @date = <$fd>;
		return @date;
	} elsif ('GLOB' eq $ref) {
	} elsif ('REFER' eq $ref 
		&& 'GLOB' eq ref $$ref) {
	} else {
	}
}


sub split_recursive_dir {
	my $dir = shift;
	my @dirs = split /\/|\/\//, $dir;
	$dirs [0] = "./" . $dirs [0] if $dirs [0] =~ /[^\.\/|w+]/;
	@dirs;
}


foreach (@ARGV) {
	my @res = &split_recursive_dir ($_);
	print "$_ -> ", "@res\n";
}

1;

END {
 	close $fd if defined $fd;
}

__END__

