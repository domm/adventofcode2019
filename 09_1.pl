use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
$intcode->input( [ 2 ]);
while (!$intcode->halted) {
    $intcode->runit;
}
say $intcode->output;

