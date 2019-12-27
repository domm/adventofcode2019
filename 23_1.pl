use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my %nodes;
for my $id ( 0 .. 49 ) {
    my $computer = $nodes{$id} = Intcode->from_file( $ARGV[0] );
    $computer->input( [ $id, -1 ] );
    $computer->runit;
}

while (1) {
    for my $id ( 0 .. 49 ) {
        my $c = $nodes{$id};
        my @output;
        while ( !$c->waiting ) {
            push( @output, $c->output );
            $c->runit;
        }
        $c->input( [-1] );
        $c->waiting(0);
        $c->runit;

        while ( my ( $target, $x, $y ) = splice( @output, 0, 3 ) ) {
            if ( $target eq '255' ) {
                say "to 255: $y";
                exit;
            }

            #say "from $id to $target: $x, $y";
            $nodes{$target}->input( [ $x, $y ] );
            $nodes{$target}->waiting(0);
            $nodes{$target}->runit;
        }
    }
}

