use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my @map;
my $intcode = Intcode->from_file($ARGV[0]);
$intcode->code->[0]=2;

#   A  L,10,R,8,R,6,R,10,
#   B  L,12,R,8,L,12,
#   A  L,10,R,8,R,6,R,10,
#   B  L,12,R,8,L,12,
#   C  L,10,R,8,R,8,
#   C  L,10,R,8,R,8,
#   B  L,12,R,8,L,12,
#   A  L,10,R,8,R,6,R,10,
#   C  L,10,R,8,R,8,
#   A  L,10,R,8,R,6,R,10'


my @inputs = (
    'A,B,A,B,C,C,B,A,C,A',
    'L,10,R,8,R,6,R,10',
    'L,12,R,8,L,12',
    'L,10,R,8,R,8',
    'n'
);
while (@inputs) {
    while (!$intcode->waiting) {
        $intcode->runit;
        print chr($intcode->output);
    }
    my $in = shift(@inputs);
    say "$in";
    $intcode->input([ map { ord($_)} split(//,$in), "\n" ]);
    $intcode->waiting(0);
}

my $clear = `clear`;
my $prev=0;
while (!$intcode->waiting) {
        $intcode->runit;
        my $o = $intcode->output;
        if ($prev == 10 && $o == 10) {
            select(undef,undef,undef,0.1);
            print $clear;
        }
        elsif ($o > 128) {
            say "GOT DUST: $o";
            exit;
        }
        elsif (chr($o) eq 'X') {
            say "lost in space";
            exit;
        }
        else {
            print chr($o);
            $prev=$o
        }
    }


#show();

__END__
sub show {
    for my $r (0 .. $#map) {
        for my $c ( 0 .. $maxc ) {
            print $map[$r]->[$c] || ' ';
        }
        print "\n";
    }
}
