use strict;
use warnings;
use Plack::Test;
use Plack::Util;
use Test::More;
use Test::Requires 'Test::WWW::Mechanize::PSGI';
use t::Utils;

my $app = setup_webapp();

{
    no warnings 'redefine';
    *Net::Akismet::new = sub {
        Plack::Util::inline_object(
            check => sub { 'false' }
        );
    };
}

my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);
$mech->max_redirect(0);
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
