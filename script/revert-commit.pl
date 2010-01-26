use strict;
use warnings;
use File::Spec;
use FindBin;
use lib File::Spec->catfile($FindBin::Bin, '..', 'lib');
use Inamode13;
my $config = do '/home/tokuhirom/local/etc/gp.ath.cx/inamode13-config.pl' or die;

my $c = Inamode13->bootstrap(config => $config);
for my $id (21..106) {
    print "-- id: $id\n";
# for my $id (12..106) {
    my $entry = $c->db->single( 'entry', { entry_id => $id } )
      or next;
      warn $entry;
    next unless $entry->body =~ /url=http:/;

    my $history_iter = $c->db->search(
        'entry_history',
        { entry_id => $id },
        { order_by => { 'entry_history_id' => 'DESC' }, }
    );
    while (my $history = $history_iter->next) {
        next if $history->body =~ /url=http:/;

        my $body = $history->body;
        $c->model('Entry')->update($entry, $body, '10.0.0.1');
        print "-- overwrote $id\n";
        last;
    }
}

