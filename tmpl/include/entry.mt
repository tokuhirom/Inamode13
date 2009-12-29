? my $entry = shift;

<div class="hentry">
    <div class="entry-no"><?= $entry->entry_id ?></div>
    <div class="entry-content"><?= $entry->html ?></div>
    <div class="clear-both">&nbsp;</div>
    <div class="entry-footer">
        <a href="/entry/<?= $entry->entry_id ?>/edit">edit</a>
? if ($entry->revision > 1) {
        <a href="/entry/<?= $entry->entry_id ?>/history">history</a>
? }
        <span class="updated bookmark"><a href="/entry/<?= $entry->entry_id ?>" rel="bookmark"><?= $entry->mtime_strftime('%Y-%m-%d(%a) %T') ?></a></span>
    </div>
</div>
