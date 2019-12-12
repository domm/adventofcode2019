use 5.028;
use strict;
use warnings;

my @map;
my $moon="A";
my %seen;
my @uni;

use Math::Utils qw(lcm);

foreach my $line (<STDIN>) {
    chomp($line);
    my($x, $y, $z) = $line=~/x=(.*?), y=(.*?), z=(.*?)>/;
    my $name = $moon++;
    push(@map,{
        name=>$name,
        x=>$x,
        y=>$y,
        z=>$z,
        vx=>0,
        vy=>0,
        vz=>0,
    });
}

my %found;
calc_seen(0);

#dump_map(0);
my $step =0;
while (1) {
    $step++;
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

    my @uni;
    # apply velocity
    for my $i (0 .. 3) {
        my $moon = $map[$i];
        my $pot=0;
        my $kin=0;
        for my $fld (qw(x y z)) {
            my $vfld='v'.$fld;
            $moon->{$fld}+=$moon->{$vfld};
        }
    }

    calc_seen($step);
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

# I figured it has to do something with LCM, but did not know about "independent axis", so I was only able to solve this after reading the reddit thread...
sub calc_seen {
    my $step = shift;
    my %ids;

    for my $moon (@map) {
        for my $dim (qw(x y z)) {
            push($ids{$dim}->@*, $moon->{$dim},$moon->{'v'.$dim});
        }
    }

    for my $dim (qw(x y z)) {
        unless (exists $found{$dim}) {
            my $id = join(',',$ids{$dim}->@*);
            if (exists $seen{$id}) {
                say "FOUND $dim sam as ".$seen{$id}." at $step";
                $found{$dim}=$step;
            }
            else {
                $seen{$id}=$step;
            }
        }
    }

    if (keys %found == 3) {
        say "step $step";
        say "will reach state again at ".lcm(values %found);
        exit;
    }

}

