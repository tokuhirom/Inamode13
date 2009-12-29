package Inamode13::M::Entry;
use strict;
use warnings;
use Inamode13::Formatter;
use Amon::Declare;
use Socket qw/inet_aton/;

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
    my $html = Inamode13::Formatter->new()->parse($body);
    $entry->update({
        title_cache => $title,
        html_cache  => $html,
    });
}

1;
