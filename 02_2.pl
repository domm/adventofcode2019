use 5.010;
use strict;
use warnings;
my @code = split( ',', <STDIN> );

for my $n ( 0 .. 99 ) {
    for my $v ( 0 .. 99 ) {
        my $res = runit( $n, $v );
        if ( $res == 19690720 ) {
            say "$n, $v ";
            say $n* 100 + $v;
            exit;
        }
    }
}

sub runit {
    my ( $n, $v ) = @_;
    my @memory = @code;

    $memory[1] = $n;
    $memory[2] = $v;
    my $pos = 0;

    while (1) {
        my $op = $memory[$pos];
        if ( $op == 99 ) {
            return $memory[0];
        }

        my ( $a, $b, $t ) = @memory[ $pos + 1, $pos + 2, $pos + 3 ];
        if ( $op == 1 ) {
            $memory[$t] = $memory[$a] + $memory[$b];
        }
        elsif ( $op == 2 ) {
            $memory[$t] = $memory[$a] * $memory[$b];
        }

        #say "$op: $a $b -> $t = " .$memory[$t];
        $pos += 4;

        #say "next pos $pos";
        #say join(', ',@memory);
        exit unless defined $memory[$pos];
    }
}
