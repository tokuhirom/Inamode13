? my ($entry, $histories, $page, $has_next) = @_;
? extends 'base.mt';
? block title => sub { $entry->title . ' - inamode13'};
? block header_part => q{<meta name="robots" content="noindex" />};

? block content => sub {

?= render_partial('include/entry.mt', $entry);

<hr />

<h2>History</h2>

<div class="histories">
? for my $history (@$histories) {
    <div class="revision"><?= $history->revision ?>.</div>
    <pre><?= $history->body ?></pre>
? }
</div>

? };
