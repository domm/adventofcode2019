use 5.028;
use strict;
use warnings;

my %o;

for (<STDIN>) {
    chomp();
    my ($a, $b) = split(/\)/,$_);

    say "$b orbits $a";
    $o{$b} = $a;
};

my %you;
my %santa;
transfer(\%you, $o{YOU}, 0,0);
my $common = transfer(\%santa, $o{SAN}, 0,1);

say $you{$common} + $santa{$common};


sub transfer {
    my ($col, $ob, $cnt, $is_santa) = @_;
    while (1) {
        return unless $ob;
        #say "ob $ob";
        if (my $p = $o{$ob}) {
            #   say "orbits $p";
            $cnt++;
            $col->{$p} = $cnt;
            if ($is_santa) {
                return $p if $you{$p};
            }
            $ob = $p;
        }
        else { return }
    }
}



