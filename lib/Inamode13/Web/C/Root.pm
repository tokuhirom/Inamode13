package Inamode13::Web::C::Root;
use strict;
use warnings;

sub index {
    my ($class, $c) = @_;
    my $page = $c->req->param('page') || 1;
    my $rows_per_page = 20;

    my @entries = $c->db->search(
        'entry' => { },
        {
            order_by => {'entry_id' => 'DESC'},
            limit    => $rows_per_page+1,
            offset   => $rows_per_page*($page-1),
        }
    );
    my $has_next =  ($rows_per_page+1 == @entries);
    if ($has_next) { pop @entries }

    $c->render("index.mt", \@entries, $page, $has_next);
}

sub rss {
    my ($class, $c) = @_;

    my (@entries) = $c->db->search(
        'entry', {},
        {
            order_by => { entry_id => 'DESC' },
            limit    => 20,
        }
    );
    $c->view('MT')
      ->make_response( 'rss.mt', \@entries )
      ->content_type('application/rss+xml');
}

1;
