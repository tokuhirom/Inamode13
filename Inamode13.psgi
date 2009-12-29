use Inamode13;
use Inamode13::Web;
use Plack::Builder;

my $config = do 'config.pl';
builder {
    enable "Plack::Middleware::Static",
            path => qr{^/static/}, root => 'htdocs/';
    Inamode13::Web->to_app(config => $config);
};
