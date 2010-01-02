? my ($entries, $page, $has_next) = @_;
? extends 'base.mt';
? block title => 'inamode13';

? block content => sub {
<div class="form-container">
    <form method="post" action="/entry">
        <p class="nm"><textarea name="body" rows="10" <? unless ((req->user_agent||'') =~ /iPhone/) { ?>cols="80"<? } ?>></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>

<div class="feed">
? for my $entry (@$entries) {
?=  render_partial('include/entry.mt', $entry);
    <hr />
? }
</div>

<div class="pager">
    <? if ($page != 1) { ?>
        <a href="<?= uri_for("/", {page => $page - 1 }) ?>" rel="prev" accesskey="4">&lt;Prev</a>
    <? } else { ?>
    &lt;Prev
    <? } ?>
    |
    <? if ($has_next) { ?>
    <a href="<?= uri_for("/", {page => $page + 1}) ?>" rel="next" accesskey="6">Next&gt;</a>
    <? } else { ?>
    Next&gt;
    <? } ?>
</div>

? };
