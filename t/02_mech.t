use strict;
use warnings;
use Plack::Test;
use Plack::Util;
use Test::More;
use Test::Requires 'Test::WWW::Mechanize::PSGI';
use t::Utils;

my $app = setup_webapp();

my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);
$mech->get_ok('/');
$mech->followable_links();
$mech->submit_form(
    form_number => 1,
    fields => {
        body => 'yay'
    }
);
is $mech->status(), 302;
$mech->get_ok($mech->res->header('Location'));
$mech->content_contains('yay');

done_testing;
