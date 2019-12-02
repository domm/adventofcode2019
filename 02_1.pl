use 5.010;
use strict;
use warnings;
my @code = split( ',', <STDIN> );
my $pos = 0;

$code[1] = 12;
$code[2] = 2;

while (1) {
    my $op = $code[$pos];
    if ( $op == 99 ) {
        say $code[0];
        exit;
    }

    my ( $a, $b, $t ) = @code[ $pos + 1, $pos + 2, $pos + 3 ];
    if ( $op == 1 ) {
        $code[$t] = $code[$a] + $code[$b];
    }
    elsif ( $op == 2 ) {
        $code[$t] = $code[$a] * $code[$b];
    }
    say "$op: $a $b -> $t = " . $code[$t];
    $pos += 4;
    say "next pos $pos";
    say join( ', ', @code );
    exit unless defined $code[$pos];
}

