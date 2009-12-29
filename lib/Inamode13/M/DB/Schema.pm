package Inamode13::M::DB::Schema;
use strict;
use warnings;
use DBIx::Skinny::Schema;
use Inamode13::Formatter;

install_table entry => schema {
    pk 'entry_id';
    columns qw/entry_id body title_cache html_cache mtime revision remote_addr/;

    my $updater = sub {
        my ($skinny, $data) = @_;
        my $body = $data->{body};
        my ($title, ) = split /\n/, $body;
        $data->{title_cache} = $title;
        $data->{html_cache} = Inamode13::Formatter->new()->parse($body);
        $data->{mtime} = time();
    };

    trigger pre_insert => $updater;
    trigger pre_update => sub {
        my ($skinny, $data) = @_;
        $data->{revision} = \"revision + 1";
        $updater->(@_);
    };
};

install_table entry_history => schema {
    pk 'entry_history_id';
    columns qw/entry_history_id entry_id body ctime revision remote_addr/;
};

1;
