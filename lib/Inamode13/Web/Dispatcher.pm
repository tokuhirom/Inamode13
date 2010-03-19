package Inamode13::Web::Dispatcher;
use Amon::Web::Dispatcher::RouterSimple -base;

connect '/',          {controller => 'Root',  action => 'index'};
connect '/entry',     {controller => 'Entry', action => 'add'};
submapper('/entry/{entry_id:[0-9]+}', controller => 'Entry')
    ->connect('',         {action => 'show'})
    ->connect('/edit',    {action => 'edit'})
    ->connect('/history', {action => 'history'})
    ->connect('/reply',   {action => 'reply'});
connect '/index.rss', {controller => 'Root',  action => 'rss'};

1;
