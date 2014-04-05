#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use mop;

# this comes up in, for instance, Plack::Middleware::wrap

class Foo {
    has $!bar is ro;

    method baz ($bar) {
        if (ref($self)) {
            $!bar = $bar;
        }
        else {
            $self = __CLASS__->new(bar => $bar);
        }

        return $self->bar;
    }
}

is(Foo->baz('BAR-class'), 'BAR-class');
is(Foo->new->baz('BAR-instance'), 'BAR-instance');


class A {
    has $!a is rw = 1;
    has $!b is rw = 2;
}

class B extends A {
    has $!b is rw = 3;
}

is(A->a, 1, '... A->a == 1');
is(A->b, 2, '... A->b == 2');
is(B->a, 1, '... B->a == 1');
is(B->b, 3, '... B->b == 3');

is(A->a(11), 11, '... A->a(11) == 11');
is(B->b(33), 33, '... B->b(33) == 33');

is(A->a, 11, '... A->a == 11');
is(B->a, 11, '... B->a == 11');
is(B->b, 33, '... B->b == 33');

my $b = B->new();

isa_ok($b, 'B');
is($b->a, 11, '... $b->a == 11');
is($b->b, 33, '... $b->b == 33');

is($b->a(111), 111, '... $b->a(111) == 111');

is($b->a, 111, '... $b->a == 111');
is(B->a, 11, '... B->a == 11');

done_testing;
