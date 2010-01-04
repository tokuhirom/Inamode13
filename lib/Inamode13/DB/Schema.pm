package Inamode13::DB::Schema;
use strict;
use warnings;
use DBIx::Skinny::Schema;
use Inamode13::Formatter;

install_table entry => schema {
    pk 'entry_id';
    columns qw/entry_id body title_cache html_cache mtime revision remote_addr anchor_ref/;
};

install_table entry_history => schema {
    pk 'entry_history_id';
    columns qw/entry_history_id entry_id body ctime revision remote_addr/;
};

1;
