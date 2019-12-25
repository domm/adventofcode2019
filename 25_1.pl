use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
use Math::Combinatorics;

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my @map;
my $intcode = Intcode->from_file($ARGV[0]);

my @collect=(
'south',
'take fixed point',
'north',
'west',
'west',
'west',
'take hologram',
'east',
'east',
'east',
'north',
'take candy cane',
'west',
'take antenna',
'west',
'take shell',
'east',
'south',
'take whirled peas',
'north',
'east',
'north',
'north',
'take polygon',
'south',
'west',
'take fuel cell',
'west',
'west',
);


my @things=(
'hologram',
'shell',
'whirled peas',
'fuel cell',
'fixed point',
'polygon',
'antenna',
'candy cane',
);

my $newline=0;
while (@collect) {
    input(shift(@collect));
    doit();
}

dropall();
#try_items(@things);
# this seems to work (but it crashes: candy cane, fixed point, polygon, shell)

my @match=('candy cane', 'fixed point', 'polygon', 'shell');
pickup(@match);
manual();

sub try_items {
    my @list = @_;
    my @try = @list;
    my $max = scalar @try;

    for my $cnt (0 .. $max) {
        my $c = Math::Combinatorics->new(
            count => $max - $cnt,
            data => \@try,
        );
        while (my @combo = $c->next_combination) {
            say "COMBO $cnt ".join(", ",sort @combo);
            dropall();
            for my $try (@combo) {
                input('take '.$try);
                doit();
            }
            input('west');
            doit();
        }
    }
}

sub manual {
    while (1) {
        my $in = <STDIN>;
        chomp($in);
        input($in);
        doit();
    }
}

sub dropall {
    for my $thing (@things) {
        input('drop '.$thing);
        doit();
    }
}
sub pickup {
    my @stuff = @_;
    for my $thing (@stuff) {
        input('take '.$thing);
        doit();
    }
}

sub input {
    my $in = shift;
    $intcode->input([ map { ord($_)} split(//,$in), "\n" ]);
    $intcode->waiting(0);
}

sub doit {
    my $output;
    while (!$intcode->waiting) {
        $intcode->runit;
        my $o = $intcode->output;
        if ($o == 10) {
            $newline++;
            exit if $newline > 10;
        }
        else {
            $newline = 0;
        }
        $output.= chr($o);
    }
    say $output;
}

