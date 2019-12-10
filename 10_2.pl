use 5.028;
use strict;
use warnings;
use Math::Vec;
use Math::Trig qw(rad2deg atan);

my @map;
foreach my $line (<STDIN>) {
    chomp($line);
    push(@map, [split(//,$line)]);
}
my $rows = $#map;
my $cols = $map[0]->@* - 1;

my $mx = 20;
my $my = 18;

my %targets;
target($mx, $my);
my %sorted;
while (my ($angle,$dists) = each %targets) {
    my @sorted = sort { $a <=> $b } keys $dists->%*;
    $sorted{$angle} = [ map { [$dists->{$_}->@*,$_] } @sorted ];
}
shoot(\%sorted);

sub target {
    my ($mx, $my) = @_;
    my $center = Math::Vec->new($mx, $my);

    for my $y (0 .. $rows) {
        for my $x (0 .. $cols) {
            next if $mx == $x && $my==$y; # self
            my $val = $map[$y]->[$x];
            next unless $val eq '#';
            my $dx = $x - $mx;
            my $dy = $y - $my;
            my $v = Math::Vec->new($dx, $dy);
            my ($a, $b, $c) = map { sprintf("%.5f", $_) }  $v->UnitVector;
            my $deg;
            if ($dx == 0) {
                $deg = $dy > 0 ? -90 : 90;
            }
            elsif ($dy == 0) {
                $deg = $dx > 0 ? 0 : -180;
            }
            else {
                $deg = rad2deg(atan( $b/$a ));
                # uff... my math sucks
                if ($dx < 0 && $dy < 0) {
                    $deg = -1 * (180+$deg);
                }
                elsif ($dx >0 && $dy <0) {
                    $deg*=-1;
                }
                elsif ($dx <0 && $dy > 0) {
                    $deg = -1 * (180+$deg);
                }
                elsif ($dx>0 && $dy>0) {
                    $deg*=-1;
                }
            }
            my $l = $v->Length;
            #say "$mx|$my => $x|$y = $dx|$dy ;$a, $b,  l = ".$l." deg ".$deg;
            $targets{$deg}{$l} = [$x,$y];
        }
    }

}

sub shoot {
    my $sorted = shift;
    my $cnt = 0;
    my @by_angle = sort { $b <=> $a } keys %$sorted;
    my $hit;
    my $nuked=0;
    while ($nuked < 200) {
        my $direction = $by_angle[$cnt++ % @by_angle];
        if (my $hits = $sorted{$direction}) {
            if (@$hits) {
                $hit = shift(@$hits);
                $nuked++;
                printf("nuked %i at %i/%i (distance %f, angle %f)\n", $nuked,@$hit, $direction);
            }
        }
    }
    say $hit->[0]*100+$hit->[1];
}


