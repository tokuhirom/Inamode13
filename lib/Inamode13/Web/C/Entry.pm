package Inamode13::Web::C::Entry;
use Amon::Web::C;
use Encode;

sub post_add {
    if (my $body = param_decoded('body')) {
        # spam check
        my $req = req();
        my $is_spam = c->get('Akismet')->check(
            USER_IP            => $req->address,
            COMMENT_USER_AGENT => $req->user_agent,
            COMMENT_CONTENT    => $body,
            REFERRER           => $req->referer,
        ) or die "Cannot check by akismet";
        if ($is_spam eq 'true') {
            return render(
                'akismet.mt'
            )->fillin_form(req)->status(403);
        }

        # insert
        my $entry = model('Entry')->insert(
            $body, req->address(),
        );
        redirect("/entry/@{[ $entry->entry_id ]}");
    } else {
        redirect('/');
    }
}

sub show {
    my $entry = db->single('entry', { entry_id => args->{entry_id} });
    return res_404() unless $entry;

    render('show.mt', $entry);
}

sub edit {
    my $entry = db->single('entry', { entry_id => args->{entry_id} });
    return redirect('/') unless $entry;

    render('edit.mt', $entry);
}

sub post_edit {
    my $entry_id = args->{entry_id};

    my $entry = db->single('entry', { entry_id => $entry_id });
    return redirect('/') unless $entry;
    my $body = param_decoded('body');
    return redirect('/') unless $body;

    my $req = req();
    my $is_spam = c->get('Akismet')->check(
        USER_IP            => $req->address,
        COMMENT_USER_AGENT => $req->user_agent,
        COMMENT_CONTENT    => $body,
        REFERRER           => $req->referer,
    ) or die "Cannot check by akismet";
    if ($is_spam eq 'true') {
        return render(
            'akismet.mt'
        )->fillin_form(req)->status(403);
    }

    model('Entry')->update(
        $entry, $body, req->address(),
    );

    redirect("/entry/@{[ $entry_id ]}");
}

sub history {
    my $entry_id = args->{entry_id};

    my $entry = db->single(entry => {entry_id => $entry_id}) or res_404();

    my $page = param('page') || 1;
    my $rows_per_page = 20;

    my @histories = db->search(
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
    my $entry_id = args->{entry_id};
    my $entry = db->single(entry => {entry_id => $entry_id}) or res_404();
    my $quote  = ">>$entry_id\n\n";
       $quote .= join "\n", map { "> $_" } split /(?:\r\n|\r|\n)/, $entry->body;
    render('reply.mt', $entry, $quote);
}

1;
