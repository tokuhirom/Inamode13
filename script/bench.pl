use Inamode13;
use Inamode13::Web;
use HTTP::Message::PSGI;
use HTTP::Request;
use Benchmark ':all';

my $req = HTTP::Request->new(GET => 'http://127.0.0.1/');

my $config = do 'config.pl';
my $app = Inamode13::Web->to_app(config => $config);
my $env = req_to_psgi($req);

timethis(1000, sub { $app->($env) });

