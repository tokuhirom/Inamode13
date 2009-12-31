? my $entry = shift;

<div class="hentry">
    <div class="entry-no"><?= $entry->entry_id ?></div>
    <div class="entry-content"><?= $entry->html ?></div>
    <div class="clear-both">&nbsp;</div>
    <div class="entry-footer">
? if ($entry->anchor_ref) {
        <div class="entry-rel">
            Rel:
?    for my $entry_id (split /,/, $entry->anchor_ref) {
            <a href="/entry/<?= $entry_id ?>"><?= $entry_id ?></a>
?    }
        </div>
? }
        <a href="/entry/<?= $entry->entry_id ?>/reply">reply</a>
        <a href="/entry/<?= $entry->entry_id ?>/edit">edit</a>
? if ($entry->revision > 1) {
        <a href="/entry/<?= $entry->entry_id ?>/history">history</a>
? }
        <span class="updated bookmark"><a href="/entry/<?= $entry->entry_id ?>" rel="bookmark"><?= $entry->mtime_strftime('%Y-%m-%d(%a) %T') ?></a></span>
    </div>
</div>
