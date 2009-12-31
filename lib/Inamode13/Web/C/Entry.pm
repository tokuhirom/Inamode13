package Inamode13::Web::C::Entry;
use Amon::Web::C;
use Encode;

sub post {
    if (my $body = param('body')) {
        $body = decode_utf8($body);
        my $entry = model('Entry')->insert(
            $body, req->address(),
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

    model('Entry')->update(
        $entry, $body, req->address(),
    );

    redirect("/entry/@{[ $entry_id ]}");
}

sub history {
    my ($class, $entry_id) = @_;

    my $entry = model('DB')->single(entry => {entry_id => $entry_id}) or res_404();

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

sub reply {
    my ($class, $entry_id) = @_;
    my $entry = model('DB')->single(entry => {entry_id => $entry_id}) or res_404();
    my $quote  = ">>$entry_id\n\n";
       $quote .= join "\n", map { "> $_" } split /(?:\r\n|\r|\n)/, $entry->body;
    render('reply.mt', $entry, $quote);
}

1;
