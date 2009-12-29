package Inamode13::Web::Dispatcher;
use Amon::Web::Dispatcher;
use feature 'switch';

sub dispatch {
    my ($class, $req) = @_;
    given ([$req->method, $req->path_info]) {
        when (['GET', '/']) {
            call("Root", 'index');
        }
        when (['POST', '/entry']) {
            call('Entry', 'post');
        }
        when (['GET', qr{^/entry/(\d+)$}]) {
            call('Entry', 'show', $1);
        }
        when (['GET', qr{^/entry/(\d+)/edit$}]) {
            call('Entry', 'edit_form', $1);
        }
        when (['POST', qr{^/entry/(\d+)/edit$}]) {
            call('Entry', 'post_edit', $1);
        }
        when (['GET', qr{^/entry/(\d+)/history$}]) {
            call('Entry', 'history', $1);
        }
        default {
            res_404();
        }
    }
}

1;
