? my ($entry) = @_;
? extends 'base.mt';
? block title => sub { $entry->title . ' - inamode13' };

? block content => sub {

<div class="feed">
?=  render_partial('include/entry.mt', $entry);
</div>

? };
