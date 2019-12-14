use 5.028;
use strict;
use warnings;

my %needs;

foreach my $line (<STDIN>) {
    chomp($line);
    my ($ins, $out) = split(/ => /,$line);
    my ($out_q,$out_p) = $out =~ /(\d+)\s(\w+)/;
    $needs{$out_p}={
        sources=>[],
        amount=>$out_q
    };

    my @ins = split(/\s?,\s?/,$ins);
    foreach (@ins) {
        my ($in_q, $in_p) = $_ =~ /(\d+)\s(\w+)/;
        push($needs{$out_p}->{sources}->@*,[$in_p, $in_q]);
    }
}
use Data::Dumper; $Data::Dumper::Maxdepth=5;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \%needs;

my $total_ore_needed=0;

my %shopping_list=();
make_list('FUEL',1,1);

use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \%shopping_list;


while (my ($prod,$amount) = each %shopping_list) {
    say "need $amount $prod";
    use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper $needs{$prod};

    my $ore_needed = $needs{$prod}->{sources}[0][1];
    my $produced =  $needs{$prod}->{amount};
    my $einheiten = $amount / $produced;
    say "to produce $produced $prod we need $ore_needed ORE";
    say "$einheiten";
    if (int($einheiten) != $einheiten) {
        $einheiten = int($einheiten) + 1;
    }
    say "we need $einheiten rounds of ORE ($produced) for a total f ".($einheiten * $ore_needed);
    $total_ore_needed +=  $einheiten * $ore_needed;
}

sub make_list {
    my ($product, $amount, $factor) = @_;
    return if $product eq 'ORE';

    say "produce $product, $amount, $factor";
    my $needed = $needs{$product}->{sources};
    foreach my $prod_info ($needed->@*) {
        if ($prod_info->[0] eq 'ORE') {
            say "need ORE for $factor $product";
            $shopping_list{$product} += $factor;
        }
        else {
            make_list($prod_info->[0], $prod_info->[1],$prod_info->[1] * $factor);
        }
    }
}

say "total ore $total_ore_needed";
exit;


