#! /usr/bin/env perl

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);

print("Starting main program\n");

my @childs;
my @logTmp;
my $max_process = 5;
our $logfh;

open($logfh, "> /tmp/fork_log.txt") or die("000000open file error\n");
close($logfh);

for (my $count = 1; $count <= $max_process; $count++) {
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
    if (-e "/tmp/fork_log_$tmp.txt") {
        print("find file /tmp/fork_log_$tmp.txt\n");
        push(@logTmp, $tmp);
    }
}

while (@logTmp) {
    my $backfh;
    my $tmp = shift @logTmp;
    open($logfh, ">> /tmp/fork_log.txt") or die("222222open file error\n");
    unless (flock($logfh, LOCK_EX | LOCK_NB)) {
        close($logfh);
        push(@logTmp, $tmp);
        print("log file is locked, next...\n");
        next;
    } else {
        open($backfh, "< /tmp/fork_log_$tmp.txt") or die("11111111open file error\n $!\n");
        while(<$backfh>) {
            print $logfh ("$_");
        }
    }
    close($logfh);
    close($backfh);
    `rm -rf /tmp/fork_log_$tmp.txt`;
}

print("End of main program\n");

sub sub1 {
    my $num = shift;
    my $fh;
    open($logfh, ">> /tmp/fork_log.txt");
    unless (flock($logfh, LOCK_EX | LOCK_NB)) {
        open($fh, "> /tmp/fork_log_" . $$ . ".txt");
    } else {
        $fh = $logfh;
    }
    select($fh);
    $| = 1;
    print("started threads $num\n");
    sleep($num);
    print("done with threads $num\n");
    close($fh);
    close($logfh);
    $logfh = undef;
    return($num);
}
