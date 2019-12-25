use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

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
manual();

#sub items {
#my @try = @things;

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

sub input {
    my $in = shift;
    $intcode->input([ map { ord($_)} split(//,$in), "\n" ]);
    $intcode->waiting(0);
}

sub doit {
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
        print chr($o);
    }
}

