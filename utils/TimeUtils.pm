#!/usr/bin/perl

package utils::TimeUtils;

use strict;
use warnings;

require Exporter;
use Time::Local;
use vars qw/@ISA @VERSION @EXPORT @EXPORT_OK/;

@ISA = qw (Exporter);
@EXPORT = @EXPORT_OK;
@EXPORT_OK = qw (
	get_cur_datetime_raw
	get_cur_datetime
	get_datetime_from_timestamp
	get_datetime_from_timestamp_raw
	get_time_format
	get_time_format1

	get_timestamp_from_hs
	get_timestamp_from_hs_raw

	equal_datetime 
	create_datetime 
	add_min add_sec add_hour add_day
	sub_min sub_sec sub_hour sub_day
);

our $VERSION = '1.1';

=head1 &get_cur_datetime_raw
Get current datetime. All each fields as an entity of a Hash.
The returned value is a Hash, whose keys are below
{second, minute, hour, day of month, month, year,
day of week, year of day, isdst}.

=head2 Note

The year must add 1900.
The month begins with 0.
Hour is 24 hour format.

=cut
sub get_cur_datetime_raw {
	&get_datetime_from_timestamp_raw (time);
}


=head1
year mon mday hour min sec
=cut
sub create_datetime {
	my %hs = (
		year => shift,
		mon => shift,
		mday => shift,
		hour => shift,
		min => shift,
		sec => shift,
		yday => 0,
		isdst => 0,
		wday => 0
	);
	%hs;
}


=head1 &get_cur_datetime
Get current datetime. 
All each fields as an entity of a Hash.

=head2 Note
The year has added 1900, the same as month (added 1).

=cut
sub get_cur_datetime {
	my %hs = &get_cur_datetime_raw;
	$hs {year} += 1900;
	$hs {mon} += 1;
	$hs {raw} = 0; # We use this fields to flag raw format.
	%hs;
}

sub get_datetime_from_timestamp_raw {
	my @tm = localtime shift;
	my %hs = ();
	map { $hs {$_} = shift @tm; } (qw/
		sec min hour mday
		mon year wday yday 
		isdst
	/);
	$hs {raw} = 1; # We use this fields to flag raw format.
	%hs;
}

sub get_datetime_from_timestamp {
	my %hs = &get_datetime_from_timestamp_raw (shift);
	$hs {year} += 1900;
	$hs {mon} += 1;
	$hs {raw} = 0;
	%hs;
}


=head1 &get_time_format
Now the current output format is YYYYMMddhhmmss (14 chars).

=cut
sub get_time_format {
	my %hs = @_;
	my $line = '';
	map { $line .= &_one_dig_to_two ($_); } 
		@hs {"year", "mon", 
			"mday", "hour", 
			"min", "sec"};
	$line;
}

sub get_time_format1 {
	my %hs = @_;
	&_one_dig_to_two ($hs {'year'}) 
	. '-' . &_one_dig_to_two ($hs {'mon'})
	. '-' . &_one_dig_to_two ($hs {'mday'})
	. ' ' . &_one_dig_to_two ($hs {'hour'})
	. ':' . &_one_dig_to_two ($hs {'min'})
	. ':' . &_one_dig_to_two ($hs {'sec'});
}


sub equal_datetime {
	my ($a, $b) = @_;
	if ($a && $b) {
		my $tm_a = &get_timestamp_from_hs (%{$a});
		my $tm_b = &get_timestamp_from_hs (%{$b});
		return 0 if $tm_a == $tm_b;
		return 1 if $tm_a < $tm_b;
		return -1 if $tm_a > $tm_b;
	}
	-2;
}

=head1 &_one_dig_to_two ($digits)
Convert a digit string from one digit to two digit.
The input string will be add with '0' if the length of digit <= 1.
e.g.  '7' => '07',  '23' => '23', '3247' => '3247'
The input string whose length > 1 will be ignored and returned
directly.

=cut
sub _one_dig_to_two {
	my $dig = shift;
	$dig = '0' . $dig
		if $dig < 10 && 
		1 >= length $dig;
	$dig;
}

=head1 &get_timestamp_from_hs (%hs)
Convert from a Hash to timestamp (ms).
Note the hash is the returned value of below subroutines:
	[get_cur_time, get_cur_time_raw]

=cut
sub get_timestamp_from_hs {
	my %hs = @_;
	my $res = undef;
	if ($hs {raw}) {
		$res = &timelocal (@hs {(qw/sec min hour mday
		mon year/)});
	} else {
		my @tmp = @hs {(qw/sec min hour mday
		mon year/)};
		$tmp [4] = &_one_dig_to_two ($tmp [4] - 1);
		$tmp [5] -= 1900;
		$res = &timelocal (@tmp);
	}
	$res;
}

=head1 &add_min (&alpha, %hs)
Add minutes from %hs. Return a new %hs.

=cut
sub add_min {
	&_add (60 * shift, @_);
}

=head1 &add_sec (&alpha, %hs)
Add seconds from %hs. Return a new %hs.

=cut
sub add_sec {
	&_add (60 * shift, @_);
}

=head1 &add_hour (&alpha, %hs)
Add hours from %hs. Return a new %hs.

=cut
sub add_hour {
	&_add (3600 * shift, @_);
}

=head1 &add_day (&alpha, %hs)
Add days from %hs. Return a new %hs.

=cut
sub add_day {
	&_add (86400 * shift, @_);
}

=head1 &sub_min (&alpha, %hs)
Subtract minutes from %hs. Return a new %hs.

=cut
sub sub_min {
	&_sub (60 * shift, @_);
}

=head1 &sub_sec ($alpha, %hs)
Subtract seconds from %hs. Return a new %hs.

=cut
sub sub_sec {
	&_sub (shift, @_);
}

=head1 &sub_hour (&alpha, %hs)
Subtract hours from %hs. Return a new %hs.

=cut
sub sub_hour {
	&_sub (3600 * shift, @_);
}

=head1 &sub_day (&alpha, %hs)
Subtract days from %hs. Return a new %hs.

=cut
sub sub_day {
	&_sub (86400 * shift, @_);
}


sub _add {
	my ($alpha, %hs) = @_;
	my $origin = &get_timestamp_from_hs (%hs);
	$origin += $alpha;
	&get_datetime_from_timestamp ($origin);
}

sub _sub {
	my ($alpha, %hs) = @_;
	my $origin = &get_timestamp_from_hs (%hs);
	$origin -= $alpha;
	&get_datetime_from_timestamp ($origin);
}

1;

__END__

=head1
=head2 Author
	ez
=head2 Date
	2016/11/11
=head2 Descirption
	Time utils. We use a hash to present a datetime.
=cut


