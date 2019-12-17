use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my @map;
my $intcode = Intcode->from_file($ARGV[0]);
say $intcode->code->[0];
$intcode->code->[0]=2;
say $intcode->code->[0];
while (!$intcode->waiting) {
    $intcode->runit;
    print chr($intcode->output);
}

my @inputs = (
    'A',
    'L,5',
    'L,5',
    'L,5',
    'y'
);

foreach my $in (@inputs) {
    say $in;
    $intcode->input([ map { ord($_)} split(//,$in), "\n" ]);
    $intcode->waiting(0);
    while (!$intcode->waiting) {
        $intcode->runit;
        print chr($intcode->output);
    }
}

say "DONE WITH NPUT";

$intcode->waiting(0);
while (!$intcode->waiting) {
    $intcode->runit;
    print chr($intcode->output);
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
