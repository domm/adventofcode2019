use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
my @code;
{
    open my $fh, '<', $ARGV[0] or die;
    local $/ = undef;
    @code = split( ',', <$fh> );
}

use List::Permutor;
my $perm = new List::Permutor qw/ 5 6 7 8 9/;
my $max  = 0;
my $maxset;
PERM: while ( my @input =$perm->next ) {
    my $output = 0;
    my $run=0;
    #say "SETTINGS ".join(',',@input);
    my @amplifiers;
    for my $i ( 0 .. 4 ) {
        my $intcode = Intcode->new([ @code] );
        push ($intcode->input->@*, $input[$i]);
        push (@amplifiers, $intcode);
    }
    push($amplifiers[0]->input->@*,0);
    TRY: while (1) {
        for my $i (0 .. 4) {
            my $intcode = $amplifiers[$i];
            $intcode->runit;
            $output = $intcode->output;
            push($amplifiers[ ($i + 1) % 5 ]->input->@*, $output);
            #say "amp $i -> $output";
        }
        if ($amplifiers[4]->halted) {
            my $final = $amplifiers[4]->output;
            if ( $final > $max ) {
                $max    = $final;
                $maxset = \@input;
            }
            last TRY;
        }
    }
}
say "max ".$max;
say join( ',', @$maxset );

