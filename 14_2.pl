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


my %stuff;
my $level=0;
my $total_ore_needed=0;

for my $f (3412000 .. 4000000) {
    $total_ore_needed=0;
    %stuff=();
    produce('FUEL',$f);
    say "$total_ore_needed => $f";
    if ($total_ore_needed > 1000000000000) {
        say $f-1;
        exit;
    }
}

sub produce {
    my ($product, $amount_needed, $ore) = @_;
    $level++;
    print "\n";
    my $deps = $needs{$product}->{sources};
    my $amount_produced = $ore || $needs{$product}->{amount};
    out("We need $amount_needed of $product");
    my ($rounds, $amount_needed)  = rounds($product, $amount_needed, $amount_produced);
    out("We need $amount_needed of $product, one round does $amount_produced, so do $rounds rounds");
    foreach my $prod_info ($deps->@*) {
        if ($prod_info->[0] eq 'ORE') {
            produce('ORE', $rounds * $prod_info->[1] ,$prod_info->[1] );
        }
        else {
            produce($prod_info->[0], $prod_info->[1] * $rounds );
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

sub rounds {
    my ($product, $amount_needed, $amount_produced) = @_;

    if (my $leftover = $stuff{$product}){
        out("still have $leftover from $product lying around, using it");
        if ($amount_needed > $leftover) {
            $amount_needed -= $leftover;
            $stuff{$product} = 0;
        }
        else {
            $stuff{$product}-=$amount_needed;
            return (0,0);
        }
    }

    my $rounds = ceil($amount_needed/$amount_produced);
    return ($rounds, $amount_needed);
}

sub out {
    #print "  " x $level;
    #say shift(@_);
}

