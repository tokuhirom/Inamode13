package Inamode13::Web::C::Entry;
use Amon::Web::C;
use Encode;

sub post {
    if (my $body = param('body')) {
        $body = decode_utf8($body);
        my $entry = model('DB')->insert(entry => { body => $body });
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

    $entry->update({body => $body});

    redirect("/entry/@{[ $entry_id ]}");
}

1;
