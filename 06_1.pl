use 5.028;
use strict;
use warnings;

my %o;

for (<STDIN>) {
    chomp();
    my ($a, $b) = split(/\)/,$_);

    say "$b orbits $a";
    $o{$b} = $a;
    #push($o{$b}->@*, $a);
};

my $total=0;
for my $ob (keys %o) {
    count($ob);
}

say $total;

sub count {
    my $ob = shift;
    #say "ob $ob";
    if (my $p = $o{$ob}) {
        #   say "orbits $p";
        $total++;
        count($p);
    }
}



