package Inamode13::Web;
use Amon::Web -base => (
    default_view_class => 'MT',
    base_class         => 'Inamode13',
);

__PACKAGE__->load_plugins('FillInForm' => {});

use Net::Akismet;

__PACKAGE__->add_factory(
    'Akismet' => sub {
        my ($c, $klass, $conf) = @_;
        Net::Akismet->new(
            URL => $c->request->uri,
            %$conf
        ) or die('Key verification failure!');
    },
);

1;
