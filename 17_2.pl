use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
use Term::ANSIColor qw(colored);

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my @map;
my $intcode = Intcode->from_file($ARGV[0]);
$intcode->code->[0]=2;

# solved using my actual brain
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
    'y'
);

$intcode->ascii_input_bulk(@inputs);

my $clear = `clear`;
my $prev=0;
my $out='';
while (!$intcode->waiting) {
    $intcode->runit;
    my $o = $intcode->output;
    if ($prev == 10 && $o == 10) {
        print $clear . $out;
        $out='';
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
        my $c = chr($o);
        if ($c =~/[<>v^]/) {
            $out.=colored($c, 'bold red');
        }
        elsif ($c eq '.') {
            $out.=' ';
        }
        else {
            $out.=$c;
        }
        $prev=$o;
    }
}

