#!perl

#
# $Id: 1.t,v 1.1 2005/01/22 05:58:48 blair Exp $
#

###

use Test::More tests => 21;;
use WWW::RaptureReady;
ok(1); # If we made it this far, we're ok.

my $local_bad  = "t/rap3.html";
my $local_good = "t/rap2.html";

###

my $rr = WWW::RaptureReady->new;
ok($rr);
isa_ok($rr, "WWW::RaptureReady");

###

ok($rr->url);
is($rr->url, "http://www.raptureready.com/rap2.html");
ok($rr->url($local_good));
is($rr->url, "file:${local_good}");
ok($rr->url("file:${local_good}"));
is($rr->url, "file:${local_good}");

###

ok($rr->url("file:${local_bad}"));
ok(!$rr->fetch);
ok($rr->url("file:${local_good}"));
ok($rr->fetch);

###

ok($rr->index);
like($rr->index, qr/^\d+$/);
is($rr->index, 153);

###

ok($rr->change);
like($rr->change, qr/^[+\-]\d+$/);
is($rr->change, "+1");

###

ok($rr->updated);
is($rr->updated, "Jan 17, 2005");

###

