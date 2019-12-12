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
    my $id = join(',',$x,$y,$z,0,0,0);
    $seen{$name}->{$id}=[0];
    push(@uni,$id);
}
$seen{universe}->{join(';',@uni)}=0;
my %first;
#dump_map(0);
for my $step (1 .. 2780) {
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
        my $id =  join(',',map {$moon->{$_}} qw(x y z vx vy vz));
        # if (exists $seen{$moon->{name}}->{$id}) {
        #     $first{$moon->{name}} ||=$step;
        #     say "$moon->{name} was here! $step";
        #     push($seen{$moon->{name}}->{$id}->@*,$id);
        # }
        # else {
        #     $seen{$moon->{name}}->{$id}=[$step];
        # }
        push(@uni,$id);
    }
    my $uniid=join(';',@uni);
    if (exists $seen{universe}->{$uniid}) {
        my $prev = $seen{universe}->{$uniid};
        say "at $step, we've been here at $prev";
        # use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \%first;

        #say lcm(values %first);
        exit;
    }
    else {
        $seen{universe}->{$uniid}=$step;
    }
    #  dump_map($step);
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

