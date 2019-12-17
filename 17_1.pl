use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
my @map;
while (!$intcode->waiting) {
    $intcode->runit;
    my $ascii = $intcode->output;
    print chr($ascii);
    push(@map,chr($ascii));
}


__END__
sub show {
    #select(undef,undef,undef,0.001);
    print $clear_string;
    #$map[30]->[30]='X';
    say "currently at $y / $x, distance: ".$dist{$y.':'.$x};
    for my $r (0 .. 45) {
        for my $c ( 0 .. 45 ) {
            if ($r == 24 && $c == 24) {
                print 'S';
            }
            elsif ($r == $y && $c == $x) {
                print '*';
            }
            else {
                print $map[$r]->[$c] || ' ';
            }
        }
        print "\n";
    }
    print "\n";

}


