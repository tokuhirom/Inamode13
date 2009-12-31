use strict;
use warnings;
use File::Spec;
use FindBin;
use lib File::Spec->catfile($FindBin::Bin, '..', 'lib');
use Inamode13::Formatter;
use Inamode13;
use Amon::Declare;
use Getopt::Long;

my $conffile = 'config.pl';
GetOptions(
    'c|config=s' => \$conffile,
);

my $config = do $conffile or die $@;
my $c = Inamode13->bootstrap(config => $config);
my $entry_iter = $c->model('DB')->search('entry');
while (my $entry = $entry_iter->next) {
    model('Entry')->set_cache($entry);
}

