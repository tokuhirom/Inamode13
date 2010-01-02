package Inamode13::Web::Dispatcher;
use Amon::Web::Dispatcher;
use feature 'switch';

sub dispatch {
    my ($class, $req) = @_;
    given ([$req->method, $req->path_info]) {
        when (['GET', '/']) {
            return call("Root", 'index');
        }
        when (['POST', '/entry']) {
            return call('Entry', 'post');
        }
        when (['GET', qr{^/entry/(\d+)$}]) {
            return call('Entry', 'show', $1);
        }
        when (['GET', qr{^/entry/(\d+)/edit$}]) {
            return call('Entry', 'edit_form', $1);
        }
        when (['POST', qr{^/entry/(\d+)/edit$}]) {
            return call('Entry', 'post_edit', $1);
        }
        when (['GET', qr{^/entry/(\d+)/history$}]) {
            return call('Entry', 'history', $1);
        }
        when (['GET', qr{^/entry/(\d+)/reply$}]) {
            return call('Entry', 'reply', $1);
        }
        when (['GET', '/index.rss']) {
            return call('Root', 'rss');
        }
        default {
            return res_404();
        }
    }
}

1;
