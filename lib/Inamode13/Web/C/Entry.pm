package Inamode13::Web::C::Entry;
use strict;
use warnings;
use Encode;

sub post_add {
    my ($class, $c) = @_;

    my $req = $c->req;
    if (my $body = $req->param_decoded('body')) {
        # spam check
        my $is_spam = $c->get('Akismet')->check(
            USER_IP            => $req->address,
            COMMENT_USER_AGENT => $req->user_agent,
            COMMENT_CONTENT    => $body,
            REFERRER           => $req->referer,
        ) or die "Cannot check by akismet";
        if ($is_spam eq 'true') {
            return $c->render(
                'akismet.mt'
            )->fillin_form($req)->status(403);
        }

        # insert
        my $entry = $c->model('Entry')->insert(
            $body, $req->address(),
        );
        $c->redirect("/entry/@{[ $entry->entry_id ]}");
    } else {
        $c->redirect('/');
    }
}

sub show {
    my ($class, $c) = @_;

    my $entry = $c->db->single('entry', { entry_id => $c->args->{entry_id} });
    return $c->res_404() unless $entry;

    $c->render('show.mt', $entry);
}

sub edit {
    my ($class, $c) = @_;

    my $entry = $c->db->single('entry', { entry_id => $c->args->{entry_id} });
    return $c->redirect('/') unless $entry;

    $c->render('edit.mt', $entry);
}

sub post_edit {
    my ($class, $c) = @_;

    my $entry_id = $c->args->{entry_id};

    my $entry = $c->db->single('entry', { entry_id => $entry_id });
    return $c->redirect('/') unless $entry;
    my $body = $c->req->param_decoded('body');
    return $c->redirect('/') unless $body;

    my $req = $c->req();
    my $is_spam = $c->get('Akismet')->check(
        USER_IP            => $req->address,
        COMMENT_USER_AGENT => $req->user_agent,
        COMMENT_CONTENT    => $body,
        REFERRER           => $req->referer,
    ) or die "Cannot check by akismet";
    if ($is_spam eq 'true') {
        return $c->render(
            'akismet.mt'
        )->fillin_form($req)->status(403);
    }

    $c->model('Entry')->update(
        $entry, $body, $c->req->address(),
    );

    $c->redirect("/entry/@{[ $entry_id ]}");
}

sub history {
    my ($class, $c) = @_;

    my $entry_id = $c->args->{entry_id};

    my $entry = $c->db->single(entry => {entry_id => $entry_id}) or $c->res_404();

    my $page = $c->req->param('page') || 1;
    my $rows_per_page = 20;

    my @histories = $c->db->search(
        'entry_history' => { entry_id => $entry_id },
        {
            order_by => {'entry_history_id' => 'DESC'},
            limit    => $rows_per_page+1,
            offset   => $rows_per_page*($page-1),
        }
    );
    my $has_next =  ($rows_per_page+1 == @histories);
    if ($has_next) { pop @histories }

    $c->render("history.mt", $entry, \@histories, $page, $has_next);
}

sub reply {
    my ($class, $c) = @_;

    my $entry_id = $c->args->{entry_id};
    my $entry = $c->db->single(entry => {entry_id => $entry_id}) or $c->res_404();
    return $c->res_404() unless $entry;

    my $quote  = ">>$entry_id\n\n";
       $quote .= join "\n", map { "> $_" } split /(?:\r\n|\r|\n)/, $entry->body;
    $c->render('reply.mt', $entry, $quote);
}

1;
