package Intcode;

use 5.010;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code));

sub runit {
    my $self = shift;

    while (1) {
        my $op = $self->code->[$self->pos];
        my $handler = 'handle_'.$op;
        my $rv = $self->$handler($self->pos);
        return if $rv == -1;
    }
}

sub get_n {
    my ($self, $pos, $n) = @_;
    my @pointer = $self->code->@[ $pos+1 .. $pos+$n ];
    $self->pos($self->pos + $n + 1);
    return @pointer;
}

sub handle_1 {
    my ($self, $pos) = @_;
    my ($x, $y, $t) = $self->get_n($pos, 3);
    $self->code->[$t] = $self->code->[$x] + $self->code->[$y];
}

sub handle_2 {
    my ($self, $pos) = @_;
    my ($x, $y, $t) = $self->get_n($pos, 3);
    $self->code->[$t] = $self->code->[$x] * $self->code->[$y];
}

sub handle_99 {
    return -1;
}

1;
