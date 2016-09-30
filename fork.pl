#! /usr/bin/env perl


use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);

print("Starting main program\n");

my @childs;
my $max_process = 5;
our $logfh;

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
    print $fh ("started threads $num\n");
    sleep($num);
    print $fh ("done with threads $num\n");
    close($fh);
    $logfh = undef;
    return($num);
}
