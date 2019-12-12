use 5.028;
use strict;
use warnings;

my @map;
my $moon="A";
foreach my $line (<STDIN>) {
    chomp($line);
    my($x, $y, $z) = $line=~/x=(.*?), y=(.*?), z=(.*?)>/;
    say "$x, $y, $z";
    push(@map,{
        name=>$moon++,
        x=>$x,
        y=>$y,
        z=>$z,
        vx=>0,
        vy=>0,
        vz=>0,
    });
}

#dump_map(0);
for my $step (1 .. 1000) {
    # apply gravity
    for my $i (0 .. 3) {
        my $moon = $map[$i];
        for my $o (1..3) {
            my $other = $map[$i+$o];
            next unless $other;
            #printf("compare %i %s with %i %s\n",$i, $moon->{name}, $o, $other->{name});
            for my $fld (qw(x y z)) {
                gravity_axis($moon, $other, $fld);
            }
        }
    }

    # apply velocity
    my $total_energy=0;
    for my $i (0 .. 3) {
        my $moon = $map[$i];
        my $pot=0;
        my $kin=0;
        for my $fld (qw(x y z)) {
            my $vfld='v'.$fld;
            $moon->{$fld}+=$moon->{$vfld};
            $pot+=abs($moon->{$fld});
            $kin+=abs($moon->{$vfld});
        }
        my $tot = $pot * $kin;
        $total_energy += $tot;
    }

    #  dump_map($step);
    say "step $step total $total_energy";
}

sub dump_map {
    my $step=shift;
    say "STEP $step";
    foreach my $m (@map) {
        printf("pos=<x=%i, y=%i, z=%i>, vel=<x=%i, y=%i, z=%i>\n",map { $m->{$_}} qw(x y z vx vy vz));
    }
}

sub gravity_axis {
    my ($moon, $other, $fld) = @_;
    my $vfld='v'.$fld;
    if ($moon->{$fld} < $other->{$fld}) {
        $moon->{$vfld}++;
        $other->{$vfld}--;
    }
    if ($moon->{$fld} > $other->{$fld}) {
        $moon->{$vfld}--;
        $other->{$vfld}++;
    }
}

