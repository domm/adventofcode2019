package Intcode;

use strict;
use warnings;
use 5.030;
use feature 'signatures';
no warnings 'experimental::signatures';

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code));

sub new ($class, $code, $pos = 0) {
    return bless {
        code => $code,
        pos  => $pos,
    }, $class;
}

sub runit ($self, $final = 0) {
    while (1) {
        my $op     = $self->code->[ $self->pos ];
        my $method = 'op_' . $op;
        last unless defined $self->$method( $self->pos );
    }
    return $self->code->[$final];
}

sub op_1 ($self, $pos) {
    my ( $x, $y, $t ) = $self->get_n( $pos, 3 );
    $self->code->[$t] = $self->code->[$x] + $self->code->[$y];
}

sub op_2 ($self, $pos) {
    my ( $x, $y, $t ) = $self->get_n( $pos, 3 );
    $self->code->[$t] = $self->code->[$x] * $self->code->[$y];
}

sub op_99 {
    return undef;
}

sub get_n ($self, $pos, $n){
    my @pointer = $self->code->@[ $pos + 1 .. $pos + $n ];
    $self->pos( $self->pos + $n + 1 );
    return @pointer;
}

1;
