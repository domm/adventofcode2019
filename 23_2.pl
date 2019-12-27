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

my @nat;
my %monitor;
while (1) {
    my $idle=0;
    for my $id ( 0 .. 49 ) {
        my $c = $nodes{$id};
        $c->runit while !$c->waiting;
        if ($c->output_buffer->@* == 0) {
            $idle++;
        }
        else {
            my ( $target, $x, $y ) = splice( $c->output_buffer->@*, 0, 3 );
            #say "from $id to $target: $x, $y";
            if ( $target eq '255' ) {
                @nat=($x,$y);
            }
            else {
                $nodes{$target}->input_and_run($x, $y);
            }
        }
        $c->input_and_run(-1);
    }

    if ($idle == 50) {
        say $nat[1];
        if ($monitor{$nat[1]}++) {
            say "first value delivered twice: ".$nat[1];
            exit;
        }

        for my $i (1 .. 49) {
            $nodes{$i}->input_and_run(-1);
        }
        $nodes{0}->input_and_run(@nat);

    }
}

