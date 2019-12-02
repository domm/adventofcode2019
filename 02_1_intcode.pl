use 5.010;
use strict;
use warnings;
use lib '.';
use Intcode;

my @code = split( ',', <STDIN> );
$code[1] = 12;
$code[2] = 2;

my $intcode = Intcode->new( @code);
say $intcode->runit;

