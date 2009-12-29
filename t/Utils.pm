package t::Utils;
use strict;
use warnings;
use base qw/Exporter/;
our @EXPORT = qw/setup_standalone setup_webapp/;
use Inamode13;
use Inamode13::Web;
use DBI;

our $DBNAME = 'test_Inamode13';
our $DBUSER = 'test';
our $DBPASS = '';
our $SETUP_DB = [
    'dbi:mysql:',
    $DBUSER,
    $DBPASS,
    {mysql_multi_statements => 1,}
];
our $CONFIG = {
    'M::DB' => {
        dsn => "dbi:mysql:database=$DBNAME",
        username => $DBUSER,
        password => $DBPASS,
    },
};
our $SCHEMA  = 'sql/mysql.sql';

sub setup_standalone {
    setup_db();
    return Inamode13->bootstrap(config => $CONFIG);
}

sub setup_webapp {
    setup_db();
    Inamode13::Web->to_app(config => $CONFIG);
}

sub setup_db {
    my $dbh = DBI->connect(@$SETUP_DB) or die;
    $dbh->do("DROP DATABASE IF EXISTS $DBNAME");
    $dbh->do("CREATE DATABASE $DBNAME");
    for my $sql (split /;/, slurp($SCHEMA)) {
        next unless $sql =~ /\S/;
        $dbh->do("use $DBNAME;$sql") or die;
    }
}

sub slurp {
    my $fname = shift;
    open my $fh, '<:utf8', $fname or die "cannot open $fname: $!";
    my $ret = do {local $/; <$fh>};
    close $fh;
    $ret;
}

1;
