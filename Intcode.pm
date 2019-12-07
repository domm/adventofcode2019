package Intcode;

use strict;
use warnings;
use 5.030;
use feature 'signatures';
no warnings 'experimental::signatures';

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code modes output input halted));

sub new ($class, $code, $pos = 0) {
    return bless {
        code => $code,
        pos  => $pos,
        modes => [],
        input => [],
        halted=>0,
    }, $class;
}

sub runit ($self, $final = 0) {
    while (1) {
        my $raw = $self->code->[ $self->read_pos ];
        chomp($raw);
        my @modes= split(//,$raw);

        my $op = join('',reverse (grep {$_} (pop(@modes),pop(@modes))));
        @modes = reverse(@modes);
        $op=~s/^0//;
        #say $self->{pos}." op $op";
        chomp($op);
        my $method = 'op_' . $op;

        $self->modes(\@modes);
        last unless defined $self->$method;
    }
    return $self->code->[$final];
}

sub op_1 ($self) { # add
    $self->set($self->get + $self->get);
}

sub op_2 ($self) { # multiply
    $self->set($self->get * $self->get);
}

sub op_3 ($self) { # input
    my $in = shift($self->input->@*);
    #say "got input ".( $in || 'nothing yet');
    unless (defined $in) {
        $self->{pos} = $self->{pos}-1;
        return undef;
    }
    $self->set($in);
}

sub op_4 ($self) { # output
    $self->output($self->get);
    return undef;
}

sub op_5 ($self) { # jump-if-true
    my $pos = $self->pos;
    my $check = $self->get;
    my $target = $self->get;
    if ($check != 0) {
        $self->pos($target);
    }
}

sub op_6 ($self) { # jump-if-false
    my $pos = $self->pos;
    my $check = $self->get;
    my $target = $self->get;
    if ($check == 0) {
        $self->pos($target);
    }
}

sub op_7 ($self) { # less then
    $self->set($self->get < $self->get ? 1 : 0);
}

sub op_8 ($self) { # equals
    $self->set($self->get == $self->get ? 1 : 0);
}

sub op_99 ($self) {
    $self->halted(1);
    return undef;
}

sub get ($self) {
    my $mode = shift(@{$self->modes}) || 0;
    my $pointer = $self->code->[$self->read_pos];
    return $mode ? $pointer : $self->code->[ $pointer];
}

sub set ($self, $val) {
    $self->code->[ $self->code->[$self->read_pos] ] = $val;
}

sub read_pos ($self) {
    my $pos = $self->pos ;
    $self->pos($pos + 1);
    return $pos;
}

1;
