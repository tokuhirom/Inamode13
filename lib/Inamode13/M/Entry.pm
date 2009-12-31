package Inamode13::M::Entry;
use strict;
use warnings;
use Inamode13::Formatter;
use Amon::Declare;
use Socket qw/inet_aton/;
use List::MoreUtils qw/uniq/;

sub new { bless {}, shift }

sub _addr {
    unpack('N*', inet_aton($_[0])) # convert to long
}

sub insert {
    my ($self, $body, $address) = @_;

    my $txn = model('DB')->txn_scope;

    my $entry = model('DB')->insert(
        entry => {
            body        => $body,
            remote_addr => _addr($address),
            mtime       => time(),
        },
    );
    $self->set_cache($entry);

    $txn->commit;

    return $entry;
}

sub update {
    my ($self, $entry, $body, $addr) = @_;
    if ($body ne $entry->body) {
        my $txn = model('DB')->txn_scope;

        model('DB')->insert(
            entry_history => {
                entry_id    => $entry->entry_id,
                body        => $entry->body,
                revision    => $entry->revision,
                ctime       => $entry->mtime,
                remote_addr => $entry->remote_addr,
            },
        );
        $entry->update({
            body        => $body,
            remote_addr => _addr($addr),
            revision    => \"revision + 1",
            mtime       => time(),
        });
        $self->set_cache($entry);

        $txn->commit;
    }

    return $entry;
}

sub set_cache {
    my ($self, $entry) = @_;

    my $body = $entry->body;
    my ($title, ) = split /\n/, $body;
    $title =~ s/^\*\s*//;
    my $html = Inamode13::Formatter->new()->parse($body);
    $entry->update({
        title_cache => $title,
        html_cache  => $html,
    });

    for my $rel_entry_id ($body =~ />>(\d+)/g) {
        my $rel_entry = model('DB')->single(entry => {entry_id => $rel_entry_id});
        my $anchor_ref = do {
            my @ids = split /,/, ($rel_entry->anchor_ref || '');
            push @ids, $entry->entry_id;
            join ',', uniq sort { $a <=> $b } @ids;
        };
        $rel_entry->update({anchor_ref => $anchor_ref});
    }
}

1;
