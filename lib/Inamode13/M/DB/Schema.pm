package Inamode13::M::DB::Schema;
use strict;
use warnings;
use DBIx::Skinny::Schema;
use Inamode13::Formatter;

install_table entry => schema {
    pk 'entry_id';
    columns qw/entry_id body title_cache html_cache mtime/;

    my $updater = sub {
        my ($skinny, $data) = @_;
        my $body = $data->{body};
        my ($title, ) = split /\n/, $body;
        $data->{title_cache} = $title;
        $data->{html_cache} = Inamode13::Formatter->new()->parse($body);
    };

    trigger pre_insert => $updater;
    trigger pre_update => $updater;
};

install_table entry_history => schema {
    pk 'entry_id';
    columns qw/entry_id body ctime/;
};

1;
