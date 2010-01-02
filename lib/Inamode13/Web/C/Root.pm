package Inamode13::Web::C::Root;
use Amon::Web::C;

sub index {
    my $page = param('page') || 1;
    my $rows_per_page = 20;

    my @entries = model('DB')->search(
        'entry' => { },
        {
            order_by => {'entry_id' => 'DESC'},
            limit    => $rows_per_page+1,
            offset   => $rows_per_page*($page-1),
        }
    );
    my $has_next =  ($rows_per_page+1 == @entries);
    if ($has_next) { pop @entries }

    render("index.mt", \@entries, $page, $has_next);
}

sub rss {
    my (@entries) = model('DB')->search(
        'entry', {},
        {
            order_by => { entry_id => 'DESC' },
            limit    => 20,
        }
    );
    my $body = view('MT')->render('rss.mt', \@entries);
    utf8::encode($body);
    return [200, ['Content-Length' => length($body), 'Content-Type' => 'application/rss+xml'], [$body]]
}

1;
