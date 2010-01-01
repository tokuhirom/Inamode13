package t::Utils;
use strict;
use warnings;
use base qw/Exporter/;
our @EXPORT = qw/setup_standalone setup_webapp/;
use Inamode13;
use Inamode13::Web;
use DBI;
use Test::mysqld;
use Test::More;

our $DBNAME = 'test_Inamode13';
our $DBUSER = 'test';
our $DBPASS = '';
our $CONFIG = {
    'M::DB' => { },
};
our $SCHEMA  = 'sql/mysql.sql';

sub setup_standalone {
    my $mysqld = setup_db();
    return Inamode13->bootstrap(config => $CONFIG, mysqld => $mysqld);
}

sub setup_webapp {
    my $mysqld = setup_db();
    Inamode13::Web->to_app(config => $CONFIG, mysqld => $mysqld);
}

sub setup_db {
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip-networking' => '',    # no TCP socket
        }
    ) or plan skip_all => $Test::mysqld::errstr;
    my $dbh = DBI->connect($mysqld->dsn()) or die;
    for my $sql (split /;/, slurp($SCHEMA)) {
        next unless $sql =~ /\S/;
        $dbh->do("$sql") or die;
    }
    $CONFIG->{'M::DB'}->{dsn} = $mysqld->dsn();
    return $mysqld;
}

sub slurp {
    my $fname = shift;
    open my $fh, '<:utf8', $fname or die "cannot open $fname: $!";
    my $ret = do {local $/; <$fh>};
    close $fh;
    $ret;
}

1;
