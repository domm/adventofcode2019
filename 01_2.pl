
use 5.010;

while (<STDIN>) { chomp; 
    #say "module mass $_"; 
    my $f = fuel($_); 
    #say "module fuel: $f"; 
    $a+=$f;
}; print $a;

sub fuel {
    my $mass = shift;
    my $fuel = int($mass/3)-2;
    $fuel = 0 if $fuel < 0;
    #say "$mass -> $fuel";
    if ($fuel > 0) {
        $fuel += fuel($fuel);
    }
    return $fuel;
}

