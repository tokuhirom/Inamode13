? my $entry = shift;

<div class="hentry">
    <div class="entry-no"><a href="<?= permalink($entry) ?>"><?= $entry->entry_id ?></a></div>
    <span class="entry-title"><?= $entry->title ?></span>
    <div class="entry-content"><?= $entry->html ?></div>
    <div class="clear-both">&nbsp;</div>
    <div class="entry-footer">
        <div class="star-container"></div>
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
        <a href="http://b.hatena.ne.jp/entry/<?= permalink($entry) ?>"><img src="http://b.hatena.ne.jp/entry/image/<?= permalink($entry) ?>" alt="B!" /></a>
        <span class="updated bookmark"><a href="<?= permalink($entry) ?>" rel="bookmark"><?= $entry->mtime_strftime('%Y-%m-%d(%a) %T') ?></a></span>
    </div>
</div>
