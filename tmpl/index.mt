? my ($entries, $page, $has_next) = @_;
? extends 'base.mt';
? block title => 'inamode13';

? block content => sub {
<div class="form-container">
    <form method="post" action="/entry">
        <p class="nm"><textarea name="body" rows="10" cols="80"></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>

<div class="feed">
? for my $entry (@$entries) {
    <div class="hentry">
        <div class="entry-no"><?= $entry->entry_id ?></div>
        <div class="entry-content"><?= $entry->html ?></div>
        <div class="clear-both">&nbsp;</div>
        <div class="entry-footer">
            <a href="/entry/<?= $entry->entry_id ?>/edit">edit</a>
            <span class="updated bookmark"><a href="/entry/<?= $entry->entry_id ?>" rel="bookmark"><?= $entry->mtime_strftime('%Y-%m-%d(%a) %T') ?></a></span>
        </div>
    </div>

    <hr />
? }
</div>
? };
