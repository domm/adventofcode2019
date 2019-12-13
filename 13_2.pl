use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

use Term::ReadKey;
ReadMode 'cbreak';

my $intcode = Intcode->from_file($ARGV[0]);
#$intcode->input( [ 2 ]);
$intcode->code->[0]=2;
my @data;
while (!$intcode->waiting) {
    $intcode->runit;
    push(@data,$intcode->output);
}

#@data = (1,2,3,6,5,4);

my @game;
my $clear_string = `clear`;

while (@data) {
    my ($x, $y, $t) = (shift(@data), shift(@data), shift(@data));
    $game[$y]->[$x] = $t;
}
my %in=(
j=>-1,
k=>0,
l=>1
);
my @score;
my $total=0;
show();
while (!$intcode->halted) {
    if ($intcode->waiting) {
        my $key;
        while (!defined $key) {
            $key = ReadKey -1;
        }
        my $in = $in{$key};
        #my $in = <STDIN>;
        chomp($in);
        die unless defined $in;
        $intcode->input([$in]);
        $intcode->waiting(0);
    }
    my @update;
    for (1..3) {
        $intcode->runit;
        push(@update,$intcode->output);
    }
    if ($update[0] == -1 && $update[1] == 0) {
        push(@score,$update[2]);
        $total+=$update[2];
        say "SCORE ".$update[2];
    }
    else {
        $game[$update[1]]->[$update[0]] = $update[2];
    }
    show();
}

# 45,75, 166,208
sub show {
    print $clear_string;
    say "j=left, k=stay, l=right    SCORE ".$total;
    for my $r ( @game ) {
        for my $c ( @$r ) {
            print $c || ' ';
        }
        print "\n";
    }
}
sub END{ReadMode 'normal' }

