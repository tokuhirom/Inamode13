use strict;
use warnings;
use t::Utils;
use Inamode13;
use Test::More;

my $c = setup_standalone();

# insert
my $entry = $c->model('DB')->insert(
    entry => {
        body => "hello, john\nokay\n- why\n"
    }
);
$entry = $c->model('DB')->single(entry => {entry_id => $entry->entry_id});
ok $entry;
like $entry->html_cache, qr/why/;
is $entry->title_cache, 'hello, john';
ok $entry->mtime;
is $entry->revision, 1;

# update
$entry->update({
    body => "okay\nfoo\nbar",
});
is $entry->title_cache, "okay";
like $entry->html_cache, qr/bar/;

# check revision number
$entry = $c->model('DB')->single(entry => {entry_id => $entry->entry_id});
is $entry->revision, 2;

# check history
my $history = $c->model('DB')->single(entry_history => {
    entry_id => $entry->entry_id
});
is $history->body, "hello, john\nokay\n- why\n", 'inserted history';
is $history->revision, 1;

done_testing;
