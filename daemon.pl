#! /usr/bin/env perl
#
# A daemon simple
#
use strict;

# become daemon
#
my $pid = fork();
print $pid,"n";

if ($pid) {
    # parent process
    print("#parent process");
    exit(0);
} else {
    print("#child process");
}

## set new process group
#setpgrp;


while(1) {
    sleep(3);
    open ("TEST", ">>/tmp/test.log");
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    $mon ++;
    print TEST ("Now is $year-$mon-$mday $hour:$min:$sec\n");
    #print("Now is $year-$mon-$mday $hour:$min:$sec\n");
    close(TEST);
}
