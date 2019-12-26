use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
use Math::Combinatorics;

my $intcode = Intcode->from_file( $ARGV[0] );

if ($ARGV[1] eq 'manual') {
    $intcode->ascii_run;
    manual();
}

my @collect = (
    'south', 'take fixed point', 'north',             'west',
    'west',  'west',             'take hologram',     'east',
    'east',  'east',             'north',             'take candy cane',
    'west',  'take antenna',     'west',              'take shell',
    'east',  'south',            'take whirled peas', 'north',
    'east',  'north',            'north',             'take polygon',
    'south', 'west',             'take fuel cell',    'west',
    'west',
);

my @things = map { my $t = $_; $t =~ s/take //; $t } grep {/take/} @collect;

$intcode->ascii_input_bulk(@collect);
$intcode->ascii_run;

try_items(@things);

# dropall();
# my @match=('candy cane', 'fixed point', 'polygon', 'shell');
# pickup(@match);
# manual();

sub manual {
    while (1) {
        my $in = <STDIN>;
        chomp($in);
        $intcode->ascii_input($in);
    }
}

sub try_items {
    my @list = @_;
    my $max  = scalar @list;
    for my $cnt ( 0 .. $max ) {
        my $c = Math::Combinatorics->new(
            count => $max - $cnt,
            data  => \@list,
        );
        while ( my @combo = $c->next_combination ) {
            $intcode->show_ascii_output(0);
            say "TRY COMBO: " . join( ', ', @combo );
            dropall();
            $intcode->ascii_input_bulk( map { 'take ' . $_ } @combo );
            $intcode->waiting(0);
            $intcode->ascii_run;
            $intcode->show_ascii_output(1);
            $intcode->ascii_input('west');
        }
    }
}

sub dropall {
    for my $thing (@things) {
        $intcode->ascii_input( 'drop ' . $thing );
    }
}

sub pickup {
    my @stuff = @_;
    for my $thing (@stuff) {
        $intcode->ascii_input( 'take ' . $thing );
    }
}

