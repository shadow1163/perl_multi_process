#! /usr/bin/env perl


use strict;
use warnings;

print("Starting main program\n");

my @childs;

for (my $count = 1; $count <= 10; $count++) {
    my $pid = fork();
    if ($pid) {
        # parent
        print("pid is $pid, parent $$\n");
        push(@childs,$pid);
    } elsif ($pid == 0) {
        # child
        sub1($count);
        exit(0);
    } else {
        die("couldnot fork: $!\n");
    }
}

foreach (@childs) {
    my $tmp = waitpid($_,0);
    print("done with pid $tmp\n");
}

print("End of main program\n");

sub sub1 {
    my $num = shift;
    print("started threads $num\n");
    sleep($num);
    print("done with threads $num\n");
    return($num);
}
