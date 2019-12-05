use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
my@code;
{open my $fh, '<', $ARGV[0] or die;
local $/ = undef;
@code = split( ',', <$fh> );
}
#$code[1] = 12;
#$code[2] = 2;

my $intcode = Intcode->new( [@code] );
say $intcode->runit;

