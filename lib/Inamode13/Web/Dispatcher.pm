package Inamode13::Web::Dispatcher;
use Amon::Web::Dispatcher;
use Router::Simple::Declare;

my $router = router {
    connect '/',          {controller => 'Root',  action => 'index'};
    connect '/entry',     {controller => 'Entry', action => 'add'};
    submapper('/entry/{id:[0-9]+}', controller => 'Entry')
        ->connect('',         {action => 'show'})
        ->connect('/edit',    {action => 'edit'})
        ->connect('/history', {action => 'history'})
        ->connect('/reply',   {action => 'reply'});
    connect '/index.rss', {controller => 'Root',  action => 'rss'};
};

sub dispatch {
    my ($class, $c) = @_;
    my $req = $c->request;
    if (my $p = $router->match($req)) {
        my $action = $req->method eq 'POST' ? "post_$p->{action}" : $p->{action};
        call($p->{controller}, $action, $p->{args}->{id});
    } else {
        res_404();
    }
}

1;
