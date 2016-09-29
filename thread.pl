#! /usr/bin/env perl
#
#

use strict;
use warnings;
use threads;
use threads::shared;

my @threads;

for(my $count = 1; $count <= 10; $count++) {
    my $t = threads->new(\&sub1, $count);
    push(@threads, $t)
}

foreach (@threads) {
    my $num = $_->join();
    print("done with $num\n");
}

print("End of main program!\n");

sub sub1 {
    my $num = shift;
    print("started threads $num\n");
    sleep($num);
    print("done with threads $num\n");
    return($num);
}
