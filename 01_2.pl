use 5.010;

while (<STDIN>) { $a+=fuel($_) }; say $a;

sub fuel {
    my $mass = shift;
    my $fuel = int($mass/3)-2;
    return 0 if $fuel <= 0;
    $fuel += fuel($fuel);
    return $fuel;
}

