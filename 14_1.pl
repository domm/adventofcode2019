use 5.028;
use strict;
use warnings;
use POSIX qw(ceil);

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

my %stuff;
my %shopping_list=();
my $level=0;
make_list('FUEL',1,1);


sub make_list {
    my ($product, $amount_needed, $ore) = @_;
    $level++;
    my $deps = $needs{$product}->{sources};
    my $amount_produced = $ore || $needs{$product}->{amount};
    out("We need $amount_needed of $product, one round does $amount_produced");
    my ($rounds,$amount_needed)  = rounds($product, $amount_needed, $amount_produced);

    if ($amount_needed < 0) {
        out("we have enough of $product");
        $stuff{$product}+=$amount_needed;
        return;
    }
    out( "produce $product: need $amount_needed; produced $amount_produced => need $rounds") ;
    foreach my $prod_info ($deps->@*) {
        if ($prod_info->[0] eq 'ORE') {
            make_list('ORE', $rounds * $prod_info->[1] ,$prod_info->[1] );
        }
        else {
            make_list($prod_info->[0], $prod_info->[1] * $rounds );
        }
    }

    my $produced = $rounds * $amount_produced;
    out("Produced $produced $product");
    if ($product eq 'ORE') {
        $total_ore_needed+= $produced if $product;
    }
    else {
        my $too_much = $produced - $amount_needed;
        if ($too_much > 0) {
            $stuff{$product} += $too_much;
            out( "We have $too_much of $product left");
        }
    }

    $level--;
}

say "total ore $total_ore_needed";
exit;

sub rounds {
    my ($product, $amount_needed, $amount_produced) = @_;

    if (my $leftover = $stuff{$product}){
        out("still have $leftover from $product lying around");
        $amount_needed -= $leftover;
    }

    my $rounds = ceil($amount_needed/$amount_produced);
    return ($rounds, $amount_needed);
}

sub out {
    print "  " x $level;
    say shift(@_);
}

