use 5.028;
use strict;
use warnings;

my %seen;
my @map;
while (my $l = <STDIN>) {
    chomp($l);
    push(@map,[ split(//,$l) ]);
}

while (1) {
    my @new;
    my $rating = 0;
    for my $r (0 .. 4) {
        for my $c (0 .. 4) {
            my $tile = $map[$r]->[$c];
            my $nb=0;
            for my $dir ([-1,0],[0,1],[1,0],[0,-1]) {
                my $lr = $r + $dir->[0];
                my $lc = $c + $dir->[1];
                next if $lr < 0 || $lr > 4;
                next if $lc < 0 || $lc > 4;
                $nb++ if $map[$lr]->[$lc] eq '#';
            }
            my $next;
            if ($tile eq '#') {
                $next = $nb == 1 ? '#' : '.';
            }
            else {
                $next = ($nb == 1 || $nb == 2) ? '#' : '.';
            }
            # say "$r / $c: $nb -> $next";
            $new[$r]->[$c]=$next;
            if ($next eq '#') {
                $rating += 2 ** ($c + $r + $r * 4);
            }
        }
    }
    @map = @new;
    if ($seen{$rating}++) {
        say "biodiversity rating: $rating";
        exit;
    }
}

