use strict;
use warnings;
use Plack::Test;
use Plack::Util;
use Test::More;
use t::Utils;

my $app = setup_webapp();
test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        do {
            my $req = HTTP::Request->new(GET => 'http://localhost/');
            my $res = $cb->($req);
            is $res->code, 200;
            diag $res->content if $res->code != 200;
        };
        do {
            my $req = HTTP::Request->new(GET => 'http://localhost/index.rss');
            my $res = $cb->($req);
            is $res->code, 200;
            diag $res->content if $res->code != 200;
        };
    };

done_testing;
