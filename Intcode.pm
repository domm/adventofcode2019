package Intcode;

use strict;
use warnings;
use 5.030;
use feature 'signatures';
no warnings 'experimental::signatures';

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(pos code modes output input halted waiting relbase));

use constant DEBUG => 0;

sub new ($class, $code, $pos = 0) {
    return bless {
        code => $code,
        pos  => $pos,
        modes => [],
        input => [],
        halted=>0,
        waiting=>0,
        relbase=>0,
    }, $class;
}

sub from_file ($class, $file) {
    my @code;
    open (my $fh, '<', $file) or die;
    local $/ = undef;
    @code = split( ',', <$fh> );
    return $class->new(\@code);
}

sub runit ($self, $final = 0) {
    while (1) {
        my $raw = $self->code->[ $self->read_pos ];
        chomp($raw);
        my $op = $raw % 100; # from https://github.com/daftmaple/aoc/blob/44d84e33656f150ea8ca60fa76105229fdec6480/2019/q09/q09.pl
        my @modes = (
            int($raw / 100) % 10,
            int($raw / 1000) % 10,
            int($raw / 10000) % 10
        );

        say $self->{pos}." op $op" if DEBUG;
        chomp($op);
        my $method = 'op_' . $op;

        $self->modes(\@modes);
        last unless defined $self->$method;
    }
    return $self->code->[$final];
}

sub op_1 ($self) { # add
    $self->val($self->val + $self->val);
}

sub op_2 ($self) { # multiply
    $self->val($self->val * $self->val);
}

sub op_3 ($self) { # input
    my $in = shift($self->input->@*);
    say "got input ".( $in || 'nothing yet') if DEBUG;
    unless (defined $in) {
        $self->waiting(1);
        $self->{pos} = $self->{pos}-1;
        return undef;
    }
    $self->val($in);
    $self->waiting(0);
}

sub op_4 ($self) { # output
    $self->output($self->val);
    return undef;
}

sub op_5 ($self) { # jump-if-true
    my $pos = $self->pos;
    my $check = $self->val;
    my $target = $self->val;
    if ($check != 0) {
        $self->pos($target);
    }
}

sub op_6 ($self) { # jump-if-false
    my $pos = $self->pos;
    my $check = $self->val;
    my $target = $self->val;
    if ($check == 0) {
        $self->pos($target);
    }
}

sub op_7 ($self) { # less then
    $self->val($self->val < $self->val ? 1 : 0);
}

sub op_8 ($self) { # equals
    $self->val($self->val == $self->val ? 1 : 0);
}

sub op_9 ($self) { # relbase
    my $base = $self->val;
    #warn "new relbase $base";
    $self->relbase($self->relbase + $base);
}

sub op_99 ($self) {
    $self->halted(1);
    return undef;
}

sub val {
    my ($self, $val) = @_;
    my $mode = shift(@{$self->modes}) || 0;
    my $pointer = $self->code->[$self->read_pos];
    say "GET $mode $pointer" if DEBUG;
    if ($mode == 0) {
        $self->code->[$pointer] = $val if defined $val;
        return $self->code->[ $pointer];
    }
    elsif ($mode == 1) {
        die "mode 1 not to be used on set!" if defined $val;
        return $pointer;
    }
    elsif ($mode == 2) {
        $self->code->[$self->relbase + $pointer] = $val if defined $val;
        return $self->code->[$self->relbase + $pointer];
    }
    die "invalid mode $mode";
}

sub read_pos ($self) {
    my $pos = $self->pos ;
    $self->pos($pos + 1);
    return $pos;
}

1;
