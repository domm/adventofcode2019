package Intcode;

use strict;
use warnings;
use 5.030;
use feature 'signatures';
no warnings 'experimental::signatures';

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code modes));

sub new ($class, $code, $pos = 0) {
    return bless {
        code => $code,
        pos  => $pos,
        modes => [],
    }, $class;
}

sub runit ($self, $final = 0) {
    while (1) {
        my $raw = $self->code->[ $self->pos ];
        chomp($raw);
        my @modes= split(//,$raw);

        my $op = join('',reverse (grep {$_} (pop(@modes),pop(@modes))));
        @modes = reverse(@modes);
        $op=~s/^0//;
        say "op $op";
        chomp($op);
        my $method = 'op_' . $op;

        $self->modes(\@modes);
        last unless defined $self->$method;

    }
    return $self->code->[$final];
}

sub op_1 ($self) {
    my ( $x, $y, $t ) = $self->get_n( 3 );
    $self->code->[$self->get_target($t)] = $self->get_val($x) + $self->get_val($y);
}

sub op_2 ($self) {
    my ( $x, $y, $t ) = $self->get_n( 3 );
    $self->code->[$self->get_target($t)] = $self->get_val($x) * $self->get_val($y);
}

sub op_3 ($self) { # input
    my ( $t ) = $self->get_n( 1 );
    print "03 input: ";
    my $in = <STDIN>;
    chomp($in);
    $self->code->[$self->get_target($t)] = $in;

}

sub op_4 ($self) { # output
    my ( $out) = $self->get_n( 1 );
    say "04 output ". $self->get_val($out);
}

sub op_99 {
    return undef;
}

sub get_n ($self, $n){
    my $pos = $self->pos;
    my $modes = $self->modes;
    my @pointer;
    for my $i (1 .. $n) {
        my $mode = $modes->[$i -1] || 0;
        my $val = $self->code->[$pos + $i];
        if ($mode == 0) {
            push(@pointer,\$val);
        }
        elsif ($mode ==1 ) {
            push(@pointer,$val);
        }
    }
    $self->pos( $pos + $n + 1 );
    $self->modes([]);
    return @pointer;
}

sub get_val ($self, $p) {
    return ref($p) ? $self->code->[$$p] : $p;
}

sub get_target ($self, $p) {
    return ref($p) ? $$p : $p;
}

1;
