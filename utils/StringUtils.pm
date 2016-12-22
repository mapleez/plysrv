#!/usr/bin/perl

package utils::StringUtils;

use strict;
use warnings;

our @chars = (
	('a' .. 'z'),
	('A' .. 'Z'),
	('0' .. '1'),
	('~', '@', '#', 
	'$', '%', '^', 
	'&', '*', '!')
);

sub rand_i {
	my ($a, $b) = @_;
	if (defined $a) {
		return int rand $a
			unless defined $b;
		if (defined $b) {
			my $diff = undef;
			if ($a > $b) {
				$diff = $a - $b;
				return $b + (int rand $diff);
			} else {
				$diff = $b - $a;
				return $a + (int rand $diff);
			}
		}
	}
	0;
}

sub rand_str {
	my ($a) = shift;
	my $str = "";
	return $str if ! $a;
	while ($a --) {
		$str .= $chars [&rand_i ($#chars)];
	}
	$str;
}

# foreach (1..20) {
# 	print &rand_str (6), "\n";
# }

1;

__END__
