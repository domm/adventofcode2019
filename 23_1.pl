use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my %nodes;
for my $id ( 0 .. 49 ) {
    my $computer = $nodes{$id} = Intcode->from_file( $ARGV[0] );
    $computer->input_and_run($id, -1);
}

while (1) {
    for my $id ( 0 .. 49 ) {
        my $c = $nodes{$id};
        my @output = $c->collect_output;

        $c->input_and_run(-1);

        while ( my ( $target, $x, $y ) = splice( @output, 0, 3 ) ) {
            if ( $target eq '255' ) {
                say "to 255: $y";
                exit;
            }
            #say "from $id to $target: $x, $y";
            $nodes{$target}->input_and_run($x, $y);
        }
    }
}

