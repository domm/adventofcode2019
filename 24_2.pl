use 5.028;
use strict;
use warnings;

my %map;
{
    my $lv = 0;
    my $r  = 0;
    while ( my $l = <STDIN> ) {
        chomp($l);
        my @c = split( //, $l );
        for my $i ( 0 .. 4 ) {
            $map{ $lv . ';' . $r . ';' . $i } = $c[$i];
        }
        $r++;
    }
    $map{'0;2;2'} = '?';
}
my %levels = ( 0 => 1 );

for my $step ( 1 .. 200 ) {
    my %next;
    my @tiles = sort keys %map;

    while (@tiles) {
        my $i = shift(@tiles);
        my $tile = $map{$i} || '.';
        my ( $level, $r, $c ) = split( ';', $i );
        my @adjacent;
        for my $dir ( [ -1, 0 ], [ 0, 1 ], [ 1, 0 ], [ 0, -1 ] ) {
            push( @adjacent,
                adjacent( $level, $r + $dir->[0], $c + $dir->[1], $r, $c, \@tiles, \%next ) );
        }
        my $nb = grep { $map{$_} && $map{$_} eq '#' } @adjacent;
        my $next = '?';
        if ( $tile eq '#' ) {
            $next = $nb == 1 ? '#' : '.';
        }
        elsif ( $tile eq '.' ) {
            $next = ( $nb == 1 || $nb == 2 ) ? '#' : '.';
        }

        # say "$i -> $level / $r / $c : $tile ; bugs $nb -> $next";
        $next{ join( ';', $level, $r, $c ) } = $next;
    }
    %map = %next;
    say "STEP $step";
}

#draw();
my $bugs = grep {/#/} values %map;
say "got $bugs bugs";

sub adjacent {
    my ( $l, $r, $c, $fr, $fc, $tiles, $newmap ) = @_;

    my @newtiles;

    # outward
    if ( $r < 0 ) {
        push( @newtiles, join( ';', $l - 1, 1, 2 ) );
    }
    elsif ( $r > 4 ) {
        push( @newtiles, join( ';', $l - 1, 3, 2 ) );
    }
    elsif ( $c < 0 ) {
        push( @newtiles, join( ';', $l - 1, 2, 1 ) );
    }
    elsif ( $c > 4 ) {
        push( @newtiles, join( ';', $l - 1, 2, 3 ) );
    }

    # inward
    elsif ( $r == 2 && $c == 2 ) {
        if ( $fr == 1 && $fc == 2 ) {
            push( @newtiles, map { join( ';', $l + 1, 0, $_ ) } ( 0 .. 4 ) );
        }
        if ( $fr == 3 && $fc == 2 ) {
            push( @newtiles, map { join( ';', $l + 1, 4, $_ ) } ( 0 .. 4 ) );
        }
        if ( $fr == 2 && $fc == 1 ) {
            push( @newtiles, map { join( ';', $l + 1, $_, 0 ) } ( 0 .. 4 ) );
        }
        if ( $fr == 2 && $fc == 3 ) {
            push( @newtiles, map { join( ';', $l + 1, $_, 4 ) } ( 0 .. 4 ) );
        }
    }

    # normal
    else {
        return join( ';', $l, $r, $c );
    }

    my @add;
    foreach my $i (@newtiles) {
        my ( $l, $c, $r ) = split( /;/, $i );
        if ( !$newmap->{$i} ) {
            $newmap->{$i} = '.';
            push( @add, $i );
        }
        if ( @add && !$levels{$l} ) {
            $levels{$l} = 1;
            for my $nr ( 0 .. 4 ) {
                for my $nc ( 0 .. 4 ) {
                    $newmap->{ join( ';', $l, $nr, $nc ) } = ( $nr == 2 && $nc == 2 ) ? '?' : 0;
                }
            }
        }
    }
    push( @$tiles, @add );
    return @newtiles;
}

sub draw {
    for my $level ( sort { $a <=> $b } keys %levels ) {
        say "\nLEVEL $level";
        my @tiles = grep { $_ =~ /^$level;/ } keys %map;
        my @map;
        for my $i (@tiles) {
            my ( $l, $r, $c ) = split( /;/, $i );
            $map[$r]->[$c] = $map{$i};
        }

        for my $r ( 0 .. 4 ) {
            for my $c ( 0 .. 4 ) {
                print $map[$r]->[$c] || '.';
            }
            print "\n";
        }
    }
}
