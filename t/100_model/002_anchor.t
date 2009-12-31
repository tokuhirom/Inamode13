use strict;
use warnings;
use t::Utils;
use Inamode13;
use Test::More;
use Amon::Declare;

my $c = setup_standalone();

my $entry1 = model('Entry')->insert(
    "hello, john\nokay\n- why\n", '127.0.0.1'
);
my $entry2 = model('Entry')->insert(
    ">>1\n", '127.0.0.1'
);
$entry1 = model('DB')->single(entry => {entry_id => $entry1->entry_id});
ok $entry1;
is $entry1->anchor_ref, '2';
my $entry3 = model('Entry')->insert(
    ">>1\n", '127.0.0.1'
);
$entry1 = model('DB')->single(entry => {entry_id => $entry1->entry_id});
is $entry1->anchor_ref, '2,3';

done_testing;
