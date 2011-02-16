#!/usr/bin/perl -T

# Core functionality tests that do not require Internet connectivity

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

# There are 5 non-method tests
plan tests => (5 + scalar(@methods));

foreach my $meth (@methods) {
  ok(WWW::OPG->can($meth), 'Method "' . $meth . '" exists.');
}

# Test the constructor initialization
my $opg = WWW::OPG->new;
isa_ok($opg, 'WWW::OPG');

# Make sure user agent looks good
ok($opg->{useragent}->agent =~ /^WWW::OPG/, 'User agent has package name');

# If no data is retrieved, the answers should be undefined
ok(!defined $opg->power, 'Power is not defined');
ok(!defined $opg->last_updated, 'Last updated timestamp is not defined');
