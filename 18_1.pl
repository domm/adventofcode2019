use 5.030;
use strict;
use warnings;

my @map;
my %keys;
my %doors;
my ( $sr, $sc ) = ( 0, 0 );

parse();

say "$sr / $sc";
my $need_keys = scalar keys %keys;
say "need keys $need_keys";
my $lowest = 99999999999;

search( [$sr, $sc, {}] );

say $lowest - 1;

sub search {
    my @todo = @_;
    while (@todo) {
        my $task = shift(@todo);
        my ( $r, $c, $holding_keys ) = @$task;
        #        say "AT $r/$c with keys "
        #            . join( '', sort keys %$holding_keys )
        #            . ' and steps '
        #            . $map[$r]->[$c]{ join( '', sort keys %$holding_keys ) };
        for my $d ( [ -1, 0 ], [ 0, 1 ], [ 1, 0 ], [ 0, -1 ] ) {
            my $dr = $r + $d->[0];
            my $dc = $c + $d->[1];

            my $look = $map[$dr]->[$dc]{tile};
            #say "look at $dr/$dc -> $look";
            next if $look eq '#';
            if ( $look =~ /[A-Z]/ && !$holding_keys->{ lc($look) } ) {
                #   say "dont have key for door $look";
                next;
            }
            next if $map[$dr]->[$dc]{ join( '', sort keys %$holding_keys ) };

            my $steps = $map[$dr]->[$dc]{ join( '', sort keys %$holding_keys ) } =
                $map[$r]->[$c]{ join( '', sort keys %$holding_keys ) } + 1;
            if (keys %$holding_keys == $need_keys && $steps < $lowest) {
                #say "holding keys $need_keys -> $steps";
                $lowest = $steps;
            }
            if ( $look !~ /[a-z]/ ) {
                #say "$dr/$dc move there";
                push(@todo, [$dr, $dc, {%$holding_keys} ]);
            }
            else {
                # say "got key $look at $dr/$dc";
                my $new_key_set = {%$holding_keys};
                $new_key_set->{$look} = 1;
                $map[$dr]->[$dc]{ join( '', sort keys %$new_key_set ) } = $steps;
                push(@todo, [$dr, $dc, {%$new_key_set} ]);
            }
        }
    }
}

sub parse {
    my $r = 0;

    for my $line (<STDIN>) {
        my $c = 0;
        chomp($line);
        for my $tile ( split( //, $line ) ) {
            if ( $tile =~ /[a-z]/ ) {
                $keys{$tile} = [ $r, $c ];
            }
            elsif ( $tile =~ /[A-Z]/ ) {
                $doors{$tile} = [ $r, $c ];
            }
            elsif ( $tile eq '@' ) {
                $sr = $r;
                $sc = $c;
            }
            $map[$r]->[$c] = { tile => $tile, ""=>0 };
            $c++;
        }
        $r++;
    }
}

