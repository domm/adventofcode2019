package Intcode;

use 5.010;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code));

sub new {
    my ( $class, @code ) = @_;
    return bless {
        code => \@code,
        pos  => 0,
    }, $class;
}

sub runit {
    my ( $self, $final ) = @_;
    $final ||= 0;

    while (1) {
        my $op     = $self->code->[ $self->pos ];
        my $method = 'op_' . $op;
        last unless defined $self->$method( $self->pos );
    }
    return $self->code->[$final];
}

sub op_1 {
    my ( $self, $pos ) = @_;
    my ( $x, $y, $t ) = $self->get_n( $pos, 3 );
    $self->code->[$t] = $self->code->[$x] + $self->code->[$y];
}

sub op_2 {
    my ( $self, $pos ) = @_;
    my ( $x, $y, $t ) = $self->get_n( $pos, 3 );
    $self->code->[$t] = $self->code->[$x] * $self->code->[$y];
}

sub op_99 {
    return undef;
}

sub get_n {
    my ( $self, $pos, $n ) = @_;
    my @pointer = $self->code->@[ $pos + 1 .. $pos + $n ];
    $self->pos( $self->pos + $n + 1 );
    return @pointer;
}

1;
