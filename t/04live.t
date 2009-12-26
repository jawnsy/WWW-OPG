#!/usr/bin/perl -T

# t/04live.t
#  Module live functionality tests (requires Internet connectivity)
#
# $Id: 04live.t 10632 2009-12-26 03:17:29Z FREQUENCY@cpan.org $

use strict;
use warnings;

use Test::More;
require Test::NoWarnings;

use WWW::OPG;

unless ($ENV{HAS_INTERNET}) {
  plan skip_all => 'Set HAS_INTERNET to enable tests requiring Internet';
}

plan tests => 7;

Test::NoWarnings->import();

my $opg = WWW::OPG->new;

eval {
  $opg->poll();
};

ok(!$@, 'No errors during retrieval');
diag($@) if $@;

diag('Power: ', $opg->power, ' MW as at ', $opg->last_updated);

ok($opg->last_updated <= DateTime->now, '->last_updated earlier than ' .
  'current time');
ok($opg->last_updated >= DateTime->now->subtract(minutes => 40),
  '->last_updated less than 40 minutes ago');
ok($opg->power > 5_000, '->power greater than 5,000 MW');
ok($opg->power < 20_000, '->power greater than 20,000 MW');

my $rc = 0;
eval {
  $rc += !!( $opg->poll() );
  $rc += !!( $opg->poll() );
};

diag ($@) if $@;

# Either zero or one of the polls can return true (not two)
ok($rc <= 1, '->poll returns 0 with no update');
