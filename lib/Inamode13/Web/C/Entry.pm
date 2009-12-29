package Inamode13::Web::C::Entry;
use Amon::Web::C;
use Encode;
use Socket qw/inet_aton/;

sub _addr {
    unpack('N*', inet_aton(req()->address()))
}

sub post {
    if (my $body = param('body')) {
        $body = decode_utf8($body);
        my $entry = model('DB')->insert(
            entry => {
                body        => $body,
                remote_addr => _addr(),
            }
        );
        redirect("/entry/@{[ $entry->entry_id ]}");
    } else {
        redirect('/');
    }
}

sub show {
    my ($class, $entry_id) = @_;
    my $entry = model('DB')->single('entry', { entry_id => $entry_id });
    return res_404() unless $entry;

    render('show.mt', $entry);
}

sub edit_form {
    my ($class, $entry_id) = @_;
    my $entry = model('DB')->single('entry', { entry_id => $entry_id });
    return redirect('/') unless $entry;

    render('edit.mt', $entry);
}

sub post_edit {
    my ($class, $entry_id) = @_;
    my $entry = model('DB')->single('entry', { entry_id => $entry_id });
    return redirect('/') unless $entry;
    my $body = param('body');
       $body = decode_utf8 $body;
    return redirect('/') unless $body;

    $entry->update(
        {
            body        => $body,
            remote_addr => _addr(),
        }
    );

    redirect("/entry/@{[ $entry_id ]}");
}

sub history {
    my ($class, $entry_id) = @_;

    my $entry = model('DB')->single(entry => {entry_id => $entry_id});

    my $page = param('page') || 1;
    my $rows_per_page = 20;

    my @histories = model('DB')->search(
        'entry_history' => { entry_id => $entry_id },
        {
            order_by => {'entry_history_id' => 'DESC'},
            limit    => $rows_per_page+1,
            offset   => $rows_per_page*($page-1),
        }
    );
    my $has_next =  ($rows_per_page+1 == @histories);
    if ($has_next) { pop @histories }

    render("history.mt", $entry, \@histories, $page, $has_next);
}

1;
