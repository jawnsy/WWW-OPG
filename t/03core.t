#!/usr/bin/perl -T

# t/03core.t
#  Core functionality tests that do not require Internet connectivity
#
# $Id: 03core.t 10632 2009-12-26 03:17:29Z FREQUENCY@cpan.org $

use strict;
use warnings;

use Test::More;
use Test::NoWarnings; # 1 test

use WWW::OPG;

# Check all core methods are defined
my @methods = (
  'new',
  'poll',
  'last_updated',
  'power',
);

# There are 2 non-method tests
plan tests => (2 + scalar(@methods));

foreach my $meth (@methods) {
  ok(WWW::OPG->can($meth), 'Method "' . $meth . '" exists.');
}

# Test the constructor initialization
my $opg = WWW::OPG->new;
isa_ok($opg, 'WWW::OPG');
