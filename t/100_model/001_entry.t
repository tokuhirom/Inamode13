use strict;
use warnings;
use t::Utils;
use Inamode13;
use Test::More;
use Amon::Declare;

my $c = setup_standalone();

# insert
my $entry = model('Entry')->insert(
    "hello, john\nokay\n- why\n", '127.0.0.1'
);
$entry = $c->db->single(entry => {entry_id => $entry->entry_id});
ok $entry;
like $entry->html_cache, qr/why/;
is $entry->title_cache, 'hello, john';
ok $entry->mtime;
is $entry->revision, 1;

# update
model('Entry')->update(
    $entry, "okay\nfoo\nbar", '127.0.0.1'
);
is $entry->title_cache, "okay";
like $entry->html_cache, qr/bar/;

# check revision number
$entry = $c->db->single(entry => {entry_id => $entry->entry_id});
is $entry->revision, 2;

# check history
my $history = $c->db->single(entry_history => {
    entry_id => $entry->entry_id
});
is $history->body, "hello, john\nokay\n- why\n", 'inserted history';
is $history->revision, 1, 'older revision';
is $c->db->count('entry_history' => entry_id => {entry_id => $entry->entry_id}), 1;

# do not change revision if body was not changed
model('Entry')->update($entry, "okay\nfoo\nbar", '127.0.0.1');
is $c->db->count('entry_history' => entry_id => {entry_id => $entry->entry_id}), 1;
$entry = $c->db->single(entry => {entry_id => $entry->entry_id});
is $entry->revision, 2;

done_testing;
