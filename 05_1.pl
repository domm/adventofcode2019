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

my $intcode = Intcode->new( [@code] );
$intcode->runit;

