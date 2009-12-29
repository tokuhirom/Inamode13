use strict;
use warnings;
use Inamode13::Formatter;
use Inamode13;
use Amon::Declare;

my $config = do 'config.pl' or die $@;
my $c = Inamode13->bootstrap(config => $config);
my $entry_iter = $c->model('DB')->search('entry');
while (my $entry = $entry_iter->next) {
    model('Entry')->set_cache($entry);
}

