? my ($entry) = @_;
? extends 'base.mt';
? block title => sub { $entry->title . ' - inamode13' };

? block content => sub {

<div class="feed">
    <div class="hentry">
        <div class="entry-no"><?= $entry->entry_id ?></div>
        <div class="entry-content"><?= $entry->html ?></div>
        <div class="clear-both">&nbsp;</div>
        <div class="updated bookmark"><a href="/entry/<?= $entry->entry_id ?>" rel="bookmark">permalink</a></div>
    </div>
</div>

? };
