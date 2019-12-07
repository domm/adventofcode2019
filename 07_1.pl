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
my $perm = new List::Permutor qw/ 0 1 2 3 4/;
my $max  = 0;
my $maxset;
while ( my @input = $perm->next ) {
    my $output = 0;
    foreach my $setting (@input) {
        my $intcode = Intcode->new( [@code] );
        $intcode->input( [ $setting, $output ] );
        $intcode->runit;
        $output = $intcode->output;
    }
    if ( $output > $max ) {
        $max    = $output;
        $maxset = \@input;
    }
}
say $max;
say join( ',', @$maxset );

