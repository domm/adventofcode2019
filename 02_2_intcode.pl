use 5.010;
use strict;
use warnings;
use lib '.';
use Intcode;

my @code = split( ',', <STDIN> );

for my $n ( 0 .. 99 ) {
    for my $v ( 0 .. 99 ) {
        $code[1] = $n;
        $code[2] = $v;
        my $intcode = Intcode->new( @code );

        my $res = $intcode->runit;
        if ( $res == 19690720 ) {
            say "$n, $v -> " . ($n* 100 + $v);
            exit;
        }
    }
}
