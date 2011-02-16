#!/usr/bin/perl -T

# Tests fast errors produced with obvious mistakes

use strict;
use warnings;

use Test::More tests => 5;
use Test::NoWarnings; # 1 test

use WWW::OPG;

# Incorrectly called methods
{
  my $obj = WWW::OPG->new();
  eval { $obj->new(); };
  ok($@, '->new called as an object method');

  eval { WWW::OPG->poll(); };
  ok($@, '->poll called as a class method');

  eval { WWW::OPG->power(); };
  ok($@, '->power called as a class method');

  eval { WWW::OPG->last_updated(); };
  ok($@, '->last_updated called as a class method');
}
